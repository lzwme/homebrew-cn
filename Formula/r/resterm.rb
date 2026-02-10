class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.21.5.tar.gz"
  sha256 "596f16d39bb1270dd3ba7707517ed52df25bff5453be5a89a59b4367f4588c92"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe191968e2feccbfa6dbc8d56cc9015094be9d7ee06e16f280f09f254d02f86a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe191968e2feccbfa6dbc8d56cc9015094be9d7ee06e16f280f09f254d02f86a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe191968e2feccbfa6dbc8d56cc9015094be9d7ee06e16f280f09f254d02f86a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d752b70f2fca2882b78527ab0dadd1301f5ab138bc4ce0c22ca249f8fb639000"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb8067c76cae3380189e89a106ffcd7b1a9c10ec16c6e4dd540b94ef96a226e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d497e280ce3e16cb9d3721487f9e0dd32476ac836de45bd6140ea73dbee4f45"
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