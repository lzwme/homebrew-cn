class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "2d8b2626dc84af6e4972501b4867902fc3e53e74ca46c00be90a3ebc6e7dea34"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76d77b7ff29c0d04a94b96dad869b3eadc78753d67432e3dee47eed8dfc3a0e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76d77b7ff29c0d04a94b96dad869b3eadc78753d67432e3dee47eed8dfc3a0e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76d77b7ff29c0d04a94b96dad869b3eadc78753d67432e3dee47eed8dfc3a0e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "434e96ad0214c91b283230654ca70021b96223226009ed45769d47980e96e4e9"
    sha256 cellar: :any,                 x86_64_linux:  "aab24c59bbb365b737c4e23136947d56744abca9d185c2348e73a58e6c8a8275"
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