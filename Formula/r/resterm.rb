class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "ed0d16ae762db244aea9ff51a891b8eb638f355d5a80069245094cb80c8ab83a"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6641db1c0372101dc5de2be82b7ca0e1897b1f6d95cbc3ba40d6612c6b017d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6641db1c0372101dc5de2be82b7ca0e1897b1f6d95cbc3ba40d6612c6b017d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6641db1c0372101dc5de2be82b7ca0e1897b1f6d95cbc3ba40d6612c6b017d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "9dcc01a9b473dee17c42f30878033d52161a3fb13493f62452ebc36baf7f1089"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e5245461ea7f5486bc66b8a38f178b99759ce1b49344598dc2f49c3338ae35d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce340e3009347ab953ef5af894d51e8524426c2d8af3ac75f46b708f17f74408"
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