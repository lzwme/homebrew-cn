class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "eaa77d3280e89e57e303877be220f61136ee4f30e1dd5ed9b08dada747f5a1bc"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "980cddc0d3219275d10cc8157db00a42f8ea403664bfd4229192c203ae4e4df2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "980cddc0d3219275d10cc8157db00a42f8ea403664bfd4229192c203ae4e4df2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "980cddc0d3219275d10cc8157db00a42f8ea403664bfd4229192c203ae4e4df2"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ab36265fd039dcf58cef2364b88b454c215c0beadbe5696fe8962d110eb5177"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38046222d050d8d1c0defd64b22f54b2b74aa70673003ae47db24a8b9ba6a018"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "315b1c8f67fbb27c2646465cf49484abb730c72db11573cd22c4f38602cae330"
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