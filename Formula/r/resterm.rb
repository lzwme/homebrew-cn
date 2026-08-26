class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "d75f6962a1d00caea17e332f91dcb4ce3662c7e40af53c42e8ce1c47c4c56115"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b809204a2e43caab155a5d3fe2bc389708fb0051a31da003b3a8095594c7cb2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b809204a2e43caab155a5d3fe2bc389708fb0051a31da003b3a8095594c7cb2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b809204a2e43caab155a5d3fe2bc389708fb0051a31da003b3a8095594c7cb2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "10f1fca10b4c392b85692ed1beb3473c95e2ad5140fb433e24b658f2aec9d3ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce76b3d26c1200b42333a4e1b8d8d52e31f621032431466eb35fb2638ea792b6"
    sha256 cellar: :any,                 x86_64_linux:  "5feb0fcb71afba074abf987d9bf814aed09e31226dcff141a055bfb82e0ea3d7"
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