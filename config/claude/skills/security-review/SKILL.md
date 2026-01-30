---
name: security-review
description: セキュリティチェックリスト（XSS, SQLi, CSRF等）を提供し、コードの脆弱性をレビュー。トリガー: "セキュリティレビュー", "脆弱性チェック", "/security-review"
---

# Security Review（セキュリティレビュー）

コードのセキュリティ脆弱性を特定・修正するための包括的チェックリスト。

> **重要**: セキュリティは選択肢ではない。一つの脆弱性がプラットフォーム全体を危険にさらす。

---

## 1. シークレット管理

### 原則
- ハードコードされた API キー、トークン、パスワードは**絶対禁止**
- すべての認証情報は環境変数で管理

### TypeScript

```typescript
// NG: ハードコード
const apiKey = 'sk-1234567890abcdef';

// OK: 環境変数
const apiKey = process.env.API_KEY;
if (!apiKey) {
  throw new Error('API_KEY environment variable is required');
}
```

### Go

```go
// NG: ハードコード
const apiKey = "sk-1234567890abcdef"

// OK: 環境変数
apiKey := os.Getenv("API_KEY")
if apiKey == "" {
    log.Fatal("API_KEY environment variable is required")
}
```

### チェック項目
- [ ] `.env` ファイルは `.gitignore` に含まれているか
- [ ] シークレットは環境変数または Secret Manager で管理されているか
- [ ] 本番環境のシークレットは開発環境と分離されているか

---

## 2. 入力検証

### 原則
- **すべての外部入力は信頼しない**
- スキーマベースのバリデーションを使用

### TypeScript（Zod）

```typescript
import { z } from 'zod';

const userInputSchema = z.object({
  email: z.string().email(),
  name: z.string().min(1).max(100),
  age: z.number().int().min(0).max(150),
});

function processInput(raw: unknown) {
  const result = userInputSchema.safeParse(raw);
  if (!result.success) {
    throw new ValidationError(result.error.issues);
  }
  return result.data;
}
```

### Go

```go
type UserInput struct {
    Email string `json:"email" validate:"required,email"`
    Name  string `json:"name" validate:"required,min=1,max=100"`
    Age   int    `json:"age" validate:"min=0,max=150"`
}

func (u *UserInput) Validate() error {
    validate := validator.New()
    return validate.Struct(u)
}
```

### ファイルアップロード

```typescript
const MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
const ALLOWED_TYPES = ['image/jpeg', 'image/png', 'application/pdf'];

function validateFile(file: File): void {
  if (file.size > MAX_FILE_SIZE) {
    throw new Error('File size exceeds limit');
  }
  if (!ALLOWED_TYPES.includes(file.type)) {
    throw new Error('File type not allowed');
  }
}
```

---

## 3. SQLインジェクション対策

### 原則
- **パラメータ化クエリを必ず使用**
- 文字列結合によるクエリ構築は禁止

### TypeScript（Prisma）

```typescript
// NG: 文字列結合
const query = `SELECT * FROM users WHERE id = '${userId}'`;

// OK: パラメータ化クエリ
const user = await prisma.user.findUnique({
  where: { id: userId }
});
```

### Go

```go
// NG: 文字列結合
query := fmt.Sprintf("SELECT * FROM users WHERE id = '%s'", userID)

// OK: パラメータ化クエリ
var user User
err := db.QueryRowContext(ctx,
    "SELECT id, name, email FROM users WHERE id = $1",
    userID,
).Scan(&user.ID, &user.Name, &user.Email)
```

---

## 4. XSS（クロスサイトスクリプティング）対策

### 原則
- ユーザー入力を出力する際は必ずサニタイズ
- CSP（Content Security Policy）ヘッダーを設定

### TypeScript

```typescript
import DOMPurify from 'dompurify';

// HTMLをサニタイズ
const sanitizedHtml = DOMPurify.sanitize(userInput);

// React: dangerouslySetInnerHTMLを使う場合は必ずサニタイズ
<div dangerouslySetInnerHTML={{ __html: DOMPurify.sanitize(content) }} />
```

### CSP ヘッダー設定

```typescript
// Next.js の場合
const securityHeaders = [
  {
    key: 'Content-Security-Policy',
    value: "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline';"
  }
];
```

```go
func securityMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        w.Header().Set("Content-Security-Policy",
            "default-src 'self'; script-src 'self'")
        w.Header().Set("X-Content-Type-Options", "nosniff")
        w.Header().Set("X-Frame-Options", "DENY")
        next.ServeHTTP(w, r)
    })
}
```

---

## 5. CSRF（クロスサイトリクエストフォージェリ）対策

### 原則
- 状態変更リクエストには CSRF トークンを使用
- SameSite Cookie 属性を設定

### TypeScript

```typescript
import csrf from 'csurf';

// Express ミドルウェア
app.use(csrf({ cookie: { httpOnly: true, sameSite: 'strict' } }));

// トークンをフォームに埋め込み
app.get('/form', (req, res) => {
  res.render('form', { csrfToken: req.csrfToken() });
});
```

### Go

```go
import "github.com/gorilla/csrf"

func main() {
    csrfMiddleware := csrf.Protect(
        []byte(os.Getenv("CSRF_KEY")),
        csrf.Secure(true),
        csrf.HttpOnly(true),
        csrf.SameSite(csrf.SameSiteStrictMode),
    )

    http.ListenAndServe(":8080", csrfMiddleware(router))
}
```

---

## 6. 認証/認可

### 原則
- トークンは httpOnly Cookie に保存
- **操作実行前に認可を確認**

### TypeScript

```typescript
// Cookie 設定
res.cookie('token', jwtToken, {
  httpOnly: true,
  secure: process.env.NODE_ENV === 'production',
  sameSite: 'strict',
  maxAge: 24 * 60 * 60 * 1000 // 24時間
});

// 認可チェック
async function deleteResource(userId: string, resourceId: string) {
  const resource = await getResource(resourceId);

  if (resource.ownerId !== userId) {
    throw new ForbiddenError('Not authorized to delete this resource');
  }

  await resource.delete();
}
```

### Go

```go
func authMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        cookie, err := r.Cookie("token")
        if err != nil {
            http.Error(w, "Unauthorized", http.StatusUnauthorized)
            return
        }

        claims, err := validateToken(cookie.Value)
        if err != nil {
            http.Error(w, "Invalid token", http.StatusUnauthorized)
            return
        }

        ctx := context.WithValue(r.Context(), "user", claims)
        next.ServeHTTP(w, r.WithContext(ctx))
    })
}
```

---

## 7. セッション管理

### チェック項目
- [ ] セッション ID は十分な長さとエントロピーを持っているか
- [ ] ログイン成功時にセッション ID を再生成しているか
- [ ] セッションタイムアウトが適切に設定されているか
- [ ] ログアウト時にセッションを完全に破棄しているか

```typescript
// ログイン成功時のセッション再生成
req.session.regenerate((err) => {
  if (err) throw err;
  req.session.userId = user.id;
  req.session.save();
});

// ログアウト時の完全破棄
req.session.destroy((err) => {
  if (err) throw err;
  res.clearCookie('connect.sid');
});
```

---

## 8. レート制限

### 原則
- API エンドポイントにレート制限を設定
- 重要な操作（ログイン、パスワードリセット）には厳格な制限

### TypeScript（Express）

```typescript
import rateLimit from 'express-rate-limit';

// 一般的なAPI制限
const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15分
  max: 100, // 100リクエスト/15分
  message: 'Too many requests, please try again later'
});

// ログイン用の厳格な制限
const loginLimiter = rateLimit({
  windowMs: 60 * 60 * 1000, // 1時間
  max: 5, // 5回/1時間
  message: 'Too many login attempts'
});

app.use('/api/', apiLimiter);
app.use('/api/auth/login', loginLimiter);
```

### Go

```go
import "golang.org/x/time/rate"

var limiter = rate.NewLimiter(rate.Every(time.Second), 10) // 10 req/sec

func rateLimitMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        if !limiter.Allow() {
            http.Error(w, "Too many requests", http.StatusTooManyRequests)
            return
        }
        next.ServeHTTP(w, r)
    })
}
```

---

## 9. ログ/監査

### 原則
- セキュリティイベントをログに記録
- **機密情報はログに含めない**

### ログに記録すべきイベント
- 認証の成功/失敗
- 認可の失敗
- 入力検証エラー
- システムエラー

```typescript
// NG: パスワードをログ出力
logger.info(`Login attempt: ${email}, ${password}`);

// OK: 機密情報を除外
logger.info('Login attempt', {
  email,
  ip: req.ip,
  timestamp: new Date().toISOString()
});
```

---

## 10. 依存関係セキュリティ

### 定期的なチェック

```bash
# Node.js
npm audit
npm audit fix

# Go
go list -m -u all
govulncheck ./...
```

### チェック項目
- [ ] 依存パッケージの脆弱性をスキャンしているか
- [ ] 重大な脆弱性は迅速に対応しているか
- [ ] 不要な依存関係を削除しているか

---

## デプロイ前チェックリスト

### シークレット
- [ ] ハードコードされたシークレットがないか
- [ ] `.env` が `.gitignore` に含まれているか
- [ ] 本番シークレットが Secret Manager で管理されているか

### 入力検証
- [ ] すべてのユーザー入力がバリデーションされているか
- [ ] ファイルアップロードにサイズ・タイプ制限があるか

### インジェクション
- [ ] SQL クエリがパラメータ化されているか
- [ ] HTML 出力がサニタイズされているか

### 認証/認可
- [ ] トークンが httpOnly Cookie に保存されているか
- [ ] すべてのエンドポイントで認可チェックがあるか
- [ ] CSRF 対策が実装されているか

### ヘッダー
- [ ] CSP ヘッダーが設定されているか
- [ ] X-Content-Type-Options: nosniff が設定されているか
- [ ] X-Frame-Options: DENY が設定されているか

### レート制限
- [ ] API エンドポイントにレート制限があるか
- [ ] ログイン試行に厳格な制限があるか

### その他
- [ ] 機密情報がログに出力されていないか
- [ ] 依存パッケージの脆弱性がスキャンされているか
- [ ] エラーメッセージが内部情報を漏らしていないか
