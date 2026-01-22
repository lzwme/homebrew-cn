class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "ea6f1fb9418730bf3e3838eb5eac8585028ebc525226c655118871bb69104451"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a956f0808defed378dbae46e18cdadf307d7f17192c46ba1fb670541d86d4fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a956f0808defed378dbae46e18cdadf307d7f17192c46ba1fb670541d86d4fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a956f0808defed378dbae46e18cdadf307d7f17192c46ba1fb670541d86d4fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "c91155ab7e1e2a944cc769dc616bfe8a276e37acee51367e625ce329792de95c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "235855c8018e75e852ea842f39884ad07725e2f6ae38460065d9b3a9ef73dadc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5675dea530d98142be9560b6a0deccf0c79eca5f15612bcddf63c3d9ef9654b2"
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