class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "25bd7568185ccea3602b15ba776071042a89e929e304e055d713084bcdfcdbff"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85f09c5325f9d004308e83f5933f5a80f100776fe8d38c74e469fa20858f5fa8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85f09c5325f9d004308e83f5933f5a80f100776fe8d38c74e469fa20858f5fa8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85f09c5325f9d004308e83f5933f5a80f100776fe8d38c74e469fa20858f5fa8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8beff1b1cb7023a2f3aa12e4b22b34234d284562f4db741821984209e5fff185"
    sha256 cellar: :any,                 x86_64_linux:  "bd80cf2df4a948eaa1e390434b393acd5fb19b0d8b4f38ed94341a5d9dbc8729"
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