class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "c474665e55ec9d7fa3e0c6a0282fbd47d780b1f376d85e31160d9d1dd71e0f51"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd6d9e412cdc16ae6899961f2c7dae1c8d5c08a95e3df973d2aad29e16e9020f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd6d9e412cdc16ae6899961f2c7dae1c8d5c08a95e3df973d2aad29e16e9020f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd6d9e412cdc16ae6899961f2c7dae1c8d5c08a95e3df973d2aad29e16e9020f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86406556657a6997b35f7a34464930ae18116dc295cb9f2d1a0dfdddae2a3e00"
    sha256 cellar: :any,                 x86_64_linux:  "77f4e02c4ce66c9fe778b648a999c5e45d1cf160c3c98efbc9a2be75d7a3adb7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/resterm"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/resterm -version")

    (testpath/"openapi.yml").write <<~YAML
      openapi: 3.0.0
      info:
        title: Test API
        version: 1.0.0
        description: A simple test API
      servers:
        - url: https://api.example.com
          description: Production server
      paths:
        /ping:
          get:
            summary: Ping endpoint
            operationId: ping
            responses:
              "200":
                description: Successful response
                content:
                  application/json:
                    schema:
                      type: object
                      properties:
                        message:
                          type: string
                          example: "pong"
      components:
        schemas:
          PingResponse:
            type: object
            properties:
              message:
                type: string
    YAML

    system bin/"resterm", "--from-openapi", testpath/"openapi.yml",
                          "--http-out",     testpath/"out.http",
                          "--openapi-base-var", "apiBase",
                          "--openapi-server-index", "0"

    assert_match "GET {{apiBase}}/ping", (testpath/"out.http").read
  end
end