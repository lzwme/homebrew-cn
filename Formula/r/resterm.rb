class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.45.2.tar.gz"
  sha256 "dfa9d4c864642d64578c29e7479a09aa0fcb24571946f9919b532c256bcef187"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26b56a9d5109c37b87e849990d1fa42f624d693c6719dc77f0e387531cbe38ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26b56a9d5109c37b87e849990d1fa42f624d693c6719dc77f0e387531cbe38ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26b56a9d5109c37b87e849990d1fa42f624d693c6719dc77f0e387531cbe38ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "f58af739b26a8c603616f94b0d60da4e89db3a8ad80066d1a5cb947de5c1393c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d2c7f58de773676de0eddb91ead178d188c96ea8fc1f9d4b03cf68970d148c1"
    sha256 cellar: :any,                 x86_64_linux:  "1e86e1a5e9802a3049de51c5e9eb2e4259199d84e808a039305630753588a0dd"
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