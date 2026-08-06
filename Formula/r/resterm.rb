class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.51.3.tar.gz"
  sha256 "8257ef6669c1ed38108b6826989e88dace531504ecf875d8b964d175908f850f"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0cd134ed861096e718191e6727a4065de62f9691dbc1c6181ffca4a338b56311"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cd134ed861096e718191e6727a4065de62f9691dbc1c6181ffca4a338b56311"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cd134ed861096e718191e6727a4065de62f9691dbc1c6181ffca4a338b56311"
    sha256 cellar: :any_skip_relocation, sonoma:        "9996be7ce9550568cbf1d4e07ce8786d45bde18791736615a572b7eede27cafc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c3287c052b632b8b3b3e41d494ad9c2ccdedcb6dad882edd2e249852424a47f"
    sha256 cellar: :any,                 x86_64_linux:  "d852824eeeea94459f4b2d72fefc5503c636e61d4c606438307489a4540576dc"
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