class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "c3f2d44aa925bb0a327e5978915eaeb5ade04334f98ed27585883bc281808042"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "19d4c17eb063b185e2cad41f34937e2c1e7d0a60ae4f11f6a166a0011f09060b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "19d4c17eb063b185e2cad41f34937e2c1e7d0a60ae4f11f6a166a0011f09060b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "19d4c17eb063b185e2cad41f34937e2c1e7d0a60ae4f11f6a166a0011f09060b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c026768f4c8416ab760bfa4c5f92ae6d3521c8fd48f689696c94b9bbc5c142d6"
    sha256 cellar: :any,                 x86_64_linux:      "353c9c4014c3676fe13b9f2fded7cf1ac632988ff6b38dbee71fe3b4709e2b06"
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