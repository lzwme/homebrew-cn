class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.44.5.tar.gz"
  sha256 "3ebe64943c787cbda2f47caf31f06b57f6f17b47e20b80d155aec75844eaa87a"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c085b01eadb3839893ec81c9f61ae12f026d9ebfada8875597fc70d721d493b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c085b01eadb3839893ec81c9f61ae12f026d9ebfada8875597fc70d721d493b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c085b01eadb3839893ec81c9f61ae12f026d9ebfada8875597fc70d721d493b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "cee4f39293c29879178185cac336a5af2cf0afb7cb3f414b8c3cbe064e8dfc37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0788b5cbd9e78c918ed79372799333bbb79994afeebeb8fedbf3cc500a3f68b8"
    sha256 cellar: :any,                 x86_64_linux:  "ae233557ddb0f7e8217491e5233bdf92c957ae67cddb4645e7d8c59630a0d2bd"
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