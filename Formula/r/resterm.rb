class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "548f43f16d23f659480888028f560ceeeda52de5b7bebb605c08e4a0f5b26e24"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "abd4316ad6f80c9d2e2c96480d7bceaf9647ecd8f88f162e663aa5e54d00fd22"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "abd4316ad6f80c9d2e2c96480d7bceaf9647ecd8f88f162e663aa5e54d00fd22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "abd4316ad6f80c9d2e2c96480d7bceaf9647ecd8f88f162e663aa5e54d00fd22"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cd9139c9a9de514509d4c474c9b22883d677978d976b76676041dbe4055ffda8"
    sha256 cellar: :any,                 x86_64_linux:      "3e55b6b221895ce864975ec44b33715892dfef8fd7fb625c6cd657340dcb4de3"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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