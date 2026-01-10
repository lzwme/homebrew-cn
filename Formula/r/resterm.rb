class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "7672b52d3745d09be1b43614066f97923cc8485489c31e97a3d67f6c4aafc64a"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85f639c033d3bb1c34d11e93cc111fdec0650e2562aa16d04b2b84139e0a09e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85f639c033d3bb1c34d11e93cc111fdec0650e2562aa16d04b2b84139e0a09e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85f639c033d3bb1c34d11e93cc111fdec0650e2562aa16d04b2b84139e0a09e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "89eaaf105986e70718406cce10ca4385e73a310a9ea18b2afbcfec360be2a0c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b05dbfafd667c4be855acbfa0e1a69fadfd916e2e2ba2c2b3cba278d9b3ca7c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e16bf3081fb6f8cbe7facd4800f07ea4bef3ab152977a115f5fa35a75162dfdc"
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