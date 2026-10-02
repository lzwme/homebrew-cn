class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.10.3.tar.gz"
  sha256 "664731d28cc78463eff0a3620c6b8eeba0d1157972ea26ae6b5773551c1404d1"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1e3e86f7ee45db439633e986e865aec41cda17fd0a20f26892d42a9f8abf894d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1e3e86f7ee45db439633e986e865aec41cda17fd0a20f26892d42a9f8abf894d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1e3e86f7ee45db439633e986e865aec41cda17fd0a20f26892d42a9f8abf894d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e042fcd0a87f9ca98dc0181d3c2ba40a736e9467e2713ef3d5f6667cc0aa4d64"
    sha256 cellar: :any,                 x86_64_linux:      "106d1f20a9e2d35df052d5476f5ac488aa77dbfe4186e1a23d812b89ee2f3f90"
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