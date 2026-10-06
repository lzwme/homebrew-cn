class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "4663b63d1dd2d9e0ae6addeb49bc209a132a0a7f3201b105a67cdf365fd53ec1"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "240077d8fb0c918a0b95bb95427b88dc95e2ba32e54b7a16980c4e7529879244"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "240077d8fb0c918a0b95bb95427b88dc95e2ba32e54b7a16980c4e7529879244"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "240077d8fb0c918a0b95bb95427b88dc95e2ba32e54b7a16980c4e7529879244"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "754025ef57bd37a2bdebf9134fb067af9659588448ec66b7014361649c9cbc6d"
    sha256 cellar: :any,                 x86_64_linux:      "c3b887522d6c3360552543d8a6774599b73f1d37b79e9452a0749064345e5e84"
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