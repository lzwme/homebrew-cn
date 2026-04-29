class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.33.4.tar.gz"
  sha256 "098f6043777460a769e06d7df0c2f74e02abca1e63de6f5f7e92b9802aa7bc10"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa72c46737266693095a46fc8952f7bd93f0c6188484469459027d6316ab3a4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa72c46737266693095a46fc8952f7bd93f0c6188484469459027d6316ab3a4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa72c46737266693095a46fc8952f7bd93f0c6188484469459027d6316ab3a4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5debc2766aca4f02b4253ef4f90dd5080db83e3ce346b300be3f2447bb1324da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d13144389598a6a2ee68433a1259800c67629b5abbc9bc4270e9ff6bace77e95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a65c7ed691f7f440f500da2f4978b4c52404c5c06e06346fa1301ee986fbfc5"
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