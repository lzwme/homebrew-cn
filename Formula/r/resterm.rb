class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.44.2.tar.gz"
  sha256 "2e3ff31ce7db953ddd9d37f3b1fe6f23cfce4dc147b000196a76576cd24612c8"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd65bd6168787d27a53a70b497c89da8a545962a33cb20151e3e18d98a283db7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd65bd6168787d27a53a70b497c89da8a545962a33cb20151e3e18d98a283db7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd65bd6168787d27a53a70b497c89da8a545962a33cb20151e3e18d98a283db7"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea478efa8138a1c7b2cba19e84ffecf18789837532a504b47148c62488e4eed0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d04c70fdb4ef30eee6ceae62540a1ee1754322a3e2bcbf1da692ba058a151700"
    sha256 cellar: :any,                 x86_64_linux:  "266976bf35cc2792b8895adb9e0814817c425df644dc6016007bff3d038c123e"
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