class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "4aaeee47a8efd788adb437d99c30b2c0f271c17103b627b70f1a3a84f2146e40"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f91cce5c0acbc764490b7b2d1ef296faeb412782a305901072030d5ec2c29a4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f91cce5c0acbc764490b7b2d1ef296faeb412782a305901072030d5ec2c29a4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f91cce5c0acbc764490b7b2d1ef296faeb412782a305901072030d5ec2c29a4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "00c07fcb6ad3993ebba8ed34a11b775d9c81f7a091d7ba814ff647b649c44fe1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0a28bcb2da28cdc95c6f84fb9687d7bde18fefd4a2f5fe8082ce89c7b4d73aa"
    sha256 cellar: :any,                 x86_64_linux:  "0507e8a4786138870e229c3366e3550c6f4f7a5bfd621c4c149b76ae92f5da1b"
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