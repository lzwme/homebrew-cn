class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.53.1.tar.gz"
  sha256 "5c6f620266f0458b28359a720d843a24f16b9bfac3cb7b305bfb1366b0d45d44"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "952d1cf75b10b455c410fd5eddf65d35b3dc82d17cd62098dfd3751c74a7c070"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "952d1cf75b10b455c410fd5eddf65d35b3dc82d17cd62098dfd3751c74a7c070"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "952d1cf75b10b455c410fd5eddf65d35b3dc82d17cd62098dfd3751c74a7c070"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd089e414164ee1161ab1e000858daf77fcc6e74f99927ab2e4821923ec62bd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fe6a69c4392fd9d327d9911f886492a75e850628d2414dff6372f80155055cf"
    sha256 cellar: :any,                 x86_64_linux:  "3c49dee45ef3496572967a76a07768bada4ec938a659fa49030ef0b5c10a39c8"
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