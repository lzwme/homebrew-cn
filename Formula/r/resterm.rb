class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.34.1.tar.gz"
  sha256 "e8f9fd2ab734c9763473058c75e2cc0b285cd76e230f3221a62bb227a12aac6c"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ae0a10a41bacf0b5bb1605ca7dccf22761f8f604c70d13b6d407b2b76c0d311"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ae0a10a41bacf0b5bb1605ca7dccf22761f8f604c70d13b6d407b2b76c0d311"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ae0a10a41bacf0b5bb1605ca7dccf22761f8f604c70d13b6d407b2b76c0d311"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3590707febdcc684d661eee5e427b2ff14a4980347816ecf4873e9ab06facd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02fb77e2f45af8c9bb2730c536906e895798bf5b8061c058ae6381aade5eccbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efacf7c97a942e5707cb5bbefdad5e15fd4d286aae462a5ce0f70a87bcadc695"
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