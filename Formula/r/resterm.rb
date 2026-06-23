class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.43.2.tar.gz"
  sha256 "a079ffacd1b2b5ff2d8e770a7b04508210ddc31c4cecc85e048161106374e66b"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35979f1347a215bf118604a7c36b5f51f59bc7c6d8f4381c26b482cf49b6a4dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35979f1347a215bf118604a7c36b5f51f59bc7c6d8f4381c26b482cf49b6a4dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35979f1347a215bf118604a7c36b5f51f59bc7c6d8f4381c26b482cf49b6a4dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "81af3ce97b4444ca9fdfa3bfdca1004825daae5e58cea8a9177ec3ede6a75fc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa31b9d692699c92dc4741cfcba639db6a7e9a344bb7311f9437ce446b0b02c1"
    sha256 cellar: :any,                 x86_64_linux:  "a3b9bbb4e76eaf885a249511d8665c77f58b1b89d9e66547532ada538d66daf5"
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