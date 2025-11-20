class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "0b6d5a96c07a6b21b12aa2551123435d6a35937b606d1266be3a0c4fe0b9da4c"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f825856f771f57ac70c732da83dfb8385b751b741a1ac5374c701827b86dac9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f825856f771f57ac70c732da83dfb8385b751b741a1ac5374c701827b86dac9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f825856f771f57ac70c732da83dfb8385b751b741a1ac5374c701827b86dac9"
    sha256 cellar: :any_skip_relocation, sonoma:        "90ea85ec8a59cd1590aa15c7de82bcd0e3c9b60c926ddc79ce9bec11bd323faa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "faf4e8ceab13a2bf6e4cdc9efe2be00872a8d705e7cf2aeeacb0d61baaeef4b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d02460b5d6affffcbc52935c8b76663df97929eb9509ba384c6ccd118c4c6f1"
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