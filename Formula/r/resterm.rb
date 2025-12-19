class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.11.6.tar.gz"
  sha256 "32d00001ab7e18f2dd423c1eb61a951ff6aa5669a9cea2432951e9e558bac58d"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "763f5f944fa17debeef97b1ea322ca8b7048a5e6ae59e43a1ce4be4673fe9754"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "763f5f944fa17debeef97b1ea322ca8b7048a5e6ae59e43a1ce4be4673fe9754"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "763f5f944fa17debeef97b1ea322ca8b7048a5e6ae59e43a1ce4be4673fe9754"
    sha256 cellar: :any_skip_relocation, sonoma:        "060c8598f8a2958b55981c3b7d6f98d0ce9ce2768767fca272626166ccaad786"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "708b94343b23639f1a0622c26570ef52cc9db33a2e725db513b11c6a2b69978e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8dfc53754dcdcefe63dcd013e9d0adb6304241e1595104c4176d8784b25ccbf"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/resterm"
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