class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "17ca00111d9f8a5c1a5d3c4e2f0a330c4406e35a6261806cca32fdea8170e4f1"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b06b7f17f338fae86ede381ab9df83e653fbfac7d7a66a8fd199aef880e518c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b06b7f17f338fae86ede381ab9df83e653fbfac7d7a66a8fd199aef880e518c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b06b7f17f338fae86ede381ab9df83e653fbfac7d7a66a8fd199aef880e518c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa51b904be0458da19d84b340cd033d8bec2758e205718a8fc341234539e9011"
    sha256 cellar: :any,                 x86_64_linux:  "929f5994e9725938d6edcaf2639db82512ac64efeebdfcc3d754e543f5c7aa9c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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