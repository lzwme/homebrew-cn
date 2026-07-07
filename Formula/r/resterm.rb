class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.44.7.tar.gz"
  sha256 "30d9a120f5e8ef8a3ca7719b836ae7beca700db332aec078531ceb8af35af31f"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df6c9e05845098078e53b26a4e02b3246f4275ea686278f948e4a233e4544cef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eed5e7e42dc3a915e423054fdf7dab9d23a058f69f43a2ee33a3aba784df7025"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28d7093d01ec1457f3c7ab9459d1a6dd32e2a561682bb51d75b9516495d93cb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed191816b1c7b56acb8c8172bb2f9f42b954d6e04caea64a50a230eb57fbfc09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cc92d594b1dfb92fc8063b9904568db49f4a20015dc655e663cf39dd32d7689"
    sha256 cellar: :any,                 x86_64_linux:  "648ae7ef52fed082dd83b7c85ad869dd0d9dd1aedb163cd503e39e1275475bd2"
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