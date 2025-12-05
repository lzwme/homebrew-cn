class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "e627f504dba16140d28befbae75849c57c07c111537d6dee8d4546451a803a9c"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8bb5ef60e9da3b8a18944775381d7680f01b64e6cc1b9eedad34c9e1e307d54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8bb5ef60e9da3b8a18944775381d7680f01b64e6cc1b9eedad34c9e1e307d54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8bb5ef60e9da3b8a18944775381d7680f01b64e6cc1b9eedad34c9e1e307d54"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ac8f86dda52b001651afa174b2affa153287677b0de18c88ee02d77add983e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e61d33e94e88530d88ff0a2b37affdce91dcd0fcf94d62ce45d751167e6361e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a176bf28c7d1831c5369d89e1cfb0cf95526ed878fba26624ed7924d17cc5dcd"
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