class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.46.4.tar.gz"
  sha256 "2c06154a491a4a328c46ea87ce7331e42e451e9aa9f95a9c1fa1af2af28a64bf"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c6813dccb0fa9ba003dc8f40bbb822d93eb27a15081ef21135dcf28a6f09c31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c6813dccb0fa9ba003dc8f40bbb822d93eb27a15081ef21135dcf28a6f09c31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c6813dccb0fa9ba003dc8f40bbb822d93eb27a15081ef21135dcf28a6f09c31"
    sha256 cellar: :any_skip_relocation, sonoma:        "898b8422b15ead7aa656a36370d06a3d97340821a041abc914ebd72121a949d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da2baadaea12c62e29497ce9aaeda7cef1f32ed3ba552045cda8cf72b8895ac1"
    sha256 cellar: :any,                 x86_64_linux:  "d6e985b75f3bbffa55fe1771c69a8e23f0f42b74e9a5931eaa2f4eb2cc0340a2"
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