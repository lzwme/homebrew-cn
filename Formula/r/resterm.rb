class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "0e36eaa2b47e69bdc73ca2cc4692a6fef0a37fb66f9332866cbccd9c0f70c329"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2fa100e79bfb416e2d7d4265511cfff5502827bb8f1c3ecd03895965d858e1c4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2fa100e79bfb416e2d7d4265511cfff5502827bb8f1c3ecd03895965d858e1c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2fa100e79bfb416e2d7d4265511cfff5502827bb8f1c3ecd03895965d858e1c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "925232fa6b604c6a0ae7829756aa5755702721d107c34722b2c6171b0f908e2f"
    sha256 cellar: :any,                 x86_64_linux:      "4277efe7257e12502c30feadb352eed250fe34b74801bae72f2ac124d966d22e"
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