class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.46.2.tar.gz"
  sha256 "9359840a1992b2bc2b7df50c08780a129e4924a4924b001d065ca34258db8d4e"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "916afe11f686ea061b049aa043744b34c4e34a7159bfcfa5100d94810e87a366"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "916afe11f686ea061b049aa043744b34c4e34a7159bfcfa5100d94810e87a366"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "916afe11f686ea061b049aa043744b34c4e34a7159bfcfa5100d94810e87a366"
    sha256 cellar: :any_skip_relocation, sonoma:        "00909173db7a10b16b439e883e572b0a3da4d4c67397c141d3f46d3871e75faa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b19a82631730e55c0c3e8e11db80e5b2099a952c8556d59174687bcf7d4caab3"
    sha256 cellar: :any,                 x86_64_linux:  "3590c1bb0242a6c1f9fcfaa10e9b1c162b44376a1eb4f700eebb41658e1e2296"
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