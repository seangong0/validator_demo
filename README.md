# ValidatorDemo

数据校验 Demo。

程序只能处理预期数据，需要对用户输入进行校验，保证程序正常运行。

## 启动

```bash
mix setup
mix phx.server
```

访问 [`localhost:4000`](http://localhost:4000)

## 目录结构

```
validator_demo/
├── config/           # 配置文件
│   ├── config.exs    # 基础配置
│   ├── dev.exs       # 开发环境配置
│   ├── prod.exs      # 生产环境配置
│   ├── runtime.exs   # 运行时配置
│   └── test.exs      # 测试环境配置
├── lib/              # 核心业务代码
│   ├── validator_demo/         # 业务逻辑层
│   │   ├── accounts/           # 用户账户模块
│   │   ├── application.ex      # 应用启动配置
│   │   ├── repo.ex             # 数据库仓储
│   │   └── schema.ex           # 数据 schema 定义
│   ├── validator_demo_web/     # Web 层
│   │   ├── controllers/        # 控制器
│   │   ├── helpers/            # 辅助函数
│   │   ├── router.ex           # 路由定义
│   │   └── validators/         # 数据校验器
│   └── validator_demo_web.ex   # Web 模块定义
├── priv/             # 私有资源
│   ├── repo/         # 数据库相关
│   │   ├── migrations/  # 数据库迁移文件
│   │   └── seeds.exs    # 数据种子
│   └── static/       # 静态资源
├── test/             # 测试代码
│   ├── support/      # 测试辅助模块
│   ├── validator_demo/       # 业务逻辑测试
│   └── validator_demo_web/   # Web 层测试
├── mix.exs           # 项目配置
└── mix.lock         # 依赖锁定文件
```
