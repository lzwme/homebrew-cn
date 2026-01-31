class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "b4e9376d23637d51952d3de5ba9cb2bab55c704e04f14bfb3850dbaf44f8d5e2"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2429cfd7656614791c72a136fb6e2495f6a1709e6ccd643647caa3ec97827ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2429cfd7656614791c72a136fb6e2495f6a1709e6ccd643647caa3ec97827ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2429cfd7656614791c72a136fb6e2495f6a1709e6ccd643647caa3ec97827ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "72431fab31e9492b674ac1141f6d9b9668fe66c7cd0ac55b977b59bc0328620c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b94c0fdadb9d4ff3efbe76f8b1d34df9bee5faafe4beca2a5a3561f7beb82a8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0242e1d259af97543cff2304b51b93263bb9231e819892b7725a0327e71f05ce"
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