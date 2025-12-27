class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "d2fd79e933a4e01ecfc2a7abe86aae46d7ab0fee3b8ab99fac8550c5b35fe9db"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9f421ab4246dbb35d7ccd925810c88f9c65dfedcba6a9163df8deded211ddfd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9f421ab4246dbb35d7ccd925810c88f9c65dfedcba6a9163df8deded211ddfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9f421ab4246dbb35d7ccd925810c88f9c65dfedcba6a9163df8deded211ddfd"
    sha256 cellar: :any_skip_relocation, sonoma:        "7153090264186a8c844a23596cd875dfd950f672cf16863d14d4d4b306b3bc65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f3c2da4d3be8c3751e44cd18798956bbe39f30a2ff9243bd44adef58ad91d11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de5625caa7832dc9e4807a547bf18474b0f2f32b5f1eb9e21beb015ec53a2da9"
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