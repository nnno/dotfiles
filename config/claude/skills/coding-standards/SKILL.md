---
name: coding-standards
description: コード品質原則、命名規則、エラーハンドリング、API設計のベストプラクティスを提供。トリガー: "コーディング標準", "コード品質", "ベストプラクティス", "/coding-standards"
---

# Coding Standards（コーディング標準）

プロジェクト全体で一貫したコード品質を維持するための標準規約。

## 基本原則

### 1. Readability First（可読性優先）
「コードは書くより読む回数の方が多い」- 明確な命名と自己文書化を優先。

### 2. KISS（Keep It Simple, Stupid）
複雑な実装より単純明快な解決策を選択。賢さより理解しやすさ。

### 3. DRY（Don't Repeat Yourself）
重複を排除し、関数・コンポーネント・ユーティリティで再利用。

### 4. YAGNI（You Aren't Gonna Need It）
今必要なものだけを実装。推測に基づく機能追加は避ける。

---

## 言語別コーディング標準

### TypeScript

#### 型安全性
```typescript
// NG: any型の使用
function process(data: any): any { ... }

// OK: 具体的な型定義
interface UserData {
  id: string;
  name: string;
  email: string;
}
function process(data: UserData): ProcessedUser { ... }
```

#### Async/Await
```typescript
// NG: 逐次実行（遅い）
const user = await getUser(id);
const posts = await getPosts(id);

// OK: 並列実行
const [user, posts] = await Promise.all([
  getUser(id),
  getPosts(id)
]);
```

#### Immutability（不変性）
```typescript
// NG: 直接変更
user.name = 'New Name';
items.push(newItem);

// OK: スプレッド演算子で新オブジェクト生成
const updatedUser = { ...user, name: 'New Name' };
const updatedItems = [...items, newItem];
```

### Go

#### エラーハンドリング
```go
// NG: エラーを無視
result, _ := someFunction()

// OK: エラーを適切に処理
result, err := someFunction()
if err != nil {
    return fmt.Errorf("someFunction failed: %w", err)
}
```

#### インターフェース設計
```go
// OK: 小さく焦点を絞ったインターフェース
type Reader interface {
    Read(p []byte) (n int, err error)
}

type Writer interface {
    Write(p []byte) (n int, err error)
}

// 必要に応じて組み合わせ
type ReadWriter interface {
    Reader
    Writer
}
```

#### Context の伝播
```go
// OK: contextを第一引数として渡す
func FetchUser(ctx context.Context, id string) (*User, error) {
    select {
    case <-ctx.Done():
        return nil, ctx.Err()
    default:
        // 処理を実行
    }
}
```

---

## 命名規則

| 要素 | TypeScript | Go |
|------|------------|-----|
| 変数/関数 | camelCase | camelCase（非公開）/ PascalCase（公開）|
| 定数 | SCREAMING_SNAKE_CASE | PascalCase |
| 型/インターフェース | PascalCase | PascalCase |
| ファイル名 | kebab-case.ts | snake_case.go |
| テストファイル | *.test.ts / *.spec.ts | *_test.go |

### 命名のベストプラクティス

```typescript
// NG: 曖昧な名前
const d = new Date();
const arr = users.filter(u => u.active);

// OK: 意図が明確な名前
const createdAt = new Date();
const activeUsers = users.filter(user => user.isActive);
```

```go
// NG: 長すぎる名前
func GetUserByIDFromDatabaseWithContext(ctx context.Context, id string) (*User, error)

// OK: 簡潔で明確
func GetUser(ctx context.Context, id string) (*User, error)
```

---

## エラーハンドリングパターン

### TypeScript

```typescript
// カスタムエラークラス
class ValidationError extends Error {
  constructor(
    message: string,
    public readonly field: string,
    public readonly code: string
  ) {
    super(message);
    this.name = 'ValidationError';
  }
}

// 使用例
async function createUser(data: CreateUserInput): Promise<User> {
  try {
    validateInput(data);
    return await userRepository.create(data);
  } catch (error) {
    if (error instanceof ValidationError) {
      throw new HttpError(400, error.message, { field: error.field });
    }
    throw new HttpError(500, 'Internal server error');
  }
}
```

### Go

```go
// カスタムエラー型
type ValidationError struct {
    Field   string
    Message string
}

func (e *ValidationError) Error() string {
    return fmt.Sprintf("validation error on %s: %s", e.Field, e.Message)
}

// エラーラッピング
func CreateUser(ctx context.Context, data CreateUserInput) (*User, error) {
    if err := validateInput(data); err != nil {
        return nil, fmt.Errorf("input validation: %w", err)
    }

    user, err := repo.Create(ctx, data)
    if err != nil {
        return nil, fmt.Errorf("create user: %w", err)
    }

    return user, nil
}
```

---

## API設計原則

### RESTful 規約

| 操作 | HTTPメソッド | パス例 |
|------|-------------|--------|
| 一覧取得 | GET | /users |
| 詳細取得 | GET | /users/:id |
| 作成 | POST | /users |
| 全体更新 | PUT | /users/:id |
| 部分更新 | PATCH | /users/:id |
| 削除 | DELETE | /users/:id |

### レスポンス形式

```typescript
// 成功レスポンス
interface SuccessResponse<T> {
  success: true;
  data: T;
}

// エラーレスポンス
interface ErrorResponse {
  success: false;
  error: {
    code: string;
    message: string;
    details?: unknown;
  };
}
```

### 入力バリデーション（Zod例）

```typescript
import { z } from 'zod';

const createUserSchema = z.object({
  name: z.string().min(1).max(100),
  email: z.string().email(),
  age: z.number().int().positive().optional(),
});

type CreateUserInput = z.infer<typeof createUserSchema>;
```

---

## テスト標準

### AAAパターン（Arrange-Act-Assert）

```typescript
describe('UserService', () => {
  it('should create user with valid input', async () => {
    // Arrange: テストデータと依存関係の準備
    const input = { name: 'Test User', email: 'test@example.com' };
    const mockRepo = { create: vi.fn().mockResolvedValue({ id: '1', ...input }) };
    const service = new UserService(mockRepo);

    // Act: テスト対象の実行
    const result = await service.createUser(input);

    // Assert: 結果の検証
    expect(result.id).toBe('1');
    expect(result.name).toBe(input.name);
    expect(mockRepo.create).toHaveBeenCalledWith(input);
  });
});
```

```go
func TestCreateUser(t *testing.T) {
    // Arrange
    ctx := context.Background()
    input := CreateUserInput{Name: "Test User", Email: "test@example.com"}
    mockRepo := &MockUserRepository{}
    service := NewUserService(mockRepo)

    // Act
    user, err := service.CreateUser(ctx, input)

    // Assert
    assert.NoError(t, err)
    assert.Equal(t, input.Name, user.Name)
}
```

---

## コード品質チェックリスト

- [ ] 関数は50行以下か
- [ ] ネストは5レベル以下か
- [ ] マジックナンバーは定数化されているか
- [ ] エラーは適切にハンドリングされているか
- [ ] 型は明示的に定義されているか（any禁止）
- [ ] 重複コードは関数化されているか
- [ ] 命名は意図を明確に表しているか
