class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "291458371421ac749880e4bc3088fef0f1c371c13dc2316f405cc957cb87f3ca"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7fffb9d021e95c93de7a0b388089bc5c3d23a9bcacea93d11f49f61775cf6d2e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7fffb9d021e95c93de7a0b388089bc5c3d23a9bcacea93d11f49f61775cf6d2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7fffb9d021e95c93de7a0b388089bc5c3d23a9bcacea93d11f49f61775cf6d2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "64fe00bb109685be5c947ce529904458555c4531a77d4d6ab3c2df6cd9159819"
    sha256 cellar: :any,                 x86_64_linux:      "be4cf43fdb4874b0eb572bd1a2dc397204b4c2d58c5723e645e481f1b346423b"
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