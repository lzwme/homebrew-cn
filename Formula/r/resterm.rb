class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.39.1.tar.gz"
  sha256 "46afdb507417a22e3e231442654cf7d1c6b66e2fed851ab32d0f05c606c67366"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d00207465590d338b03182358aec6da815531eabe5d11e0d6fc7503cc1c89547"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d00207465590d338b03182358aec6da815531eabe5d11e0d6fc7503cc1c89547"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d00207465590d338b03182358aec6da815531eabe5d11e0d6fc7503cc1c89547"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9a2c9d5b49908bb1d7faa19ddb0b6a9524c7fc23df67590796b6c069f7040bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffeb521d04b7f652ab3f8bee2256effea0903bc3af656a11114221f4d6c5f65a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c672e1d920d7cf536436db1e775a359f1830fd1a4e38a637d086b2d199d23b71"
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