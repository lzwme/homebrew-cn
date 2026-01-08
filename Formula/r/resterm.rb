class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "a53bb455f584d8bc834fd3563e8f0a8951328f3d32200b2475854c83eb14584d"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0af5c34d006c77b2d7f58a40d3dba03d7b2fa35a8fac3fc19db36957e93fa69a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0af5c34d006c77b2d7f58a40d3dba03d7b2fa35a8fac3fc19db36957e93fa69a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0af5c34d006c77b2d7f58a40d3dba03d7b2fa35a8fac3fc19db36957e93fa69a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c748abc55bf41dcb725ea6566175b45626e1987d687233e6b006dad46521b1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3836519d58207a2e5e916b5c3b27fd06b876cba918eb1b8b99700ec291eeaab7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f5b5c4840d38432aae726e42f6aa7bf0363f1ef41f1623d12759ae3a833388c"
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