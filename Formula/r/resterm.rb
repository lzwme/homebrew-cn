class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "5118f3e1d12b8dcee114159b0e0f8858eeff2cfbf40400d59b0de994773e8b94"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "518895631ca947b2788836cd940ada8f2f4b6f37737ee1e2f80fa86a8c27fab8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "518895631ca947b2788836cd940ada8f2f4b6f37737ee1e2f80fa86a8c27fab8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "518895631ca947b2788836cd940ada8f2f4b6f37737ee1e2f80fa86a8c27fab8"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2e5d8daf4e3ae3e455312ce80a71e77c37c24a12506bcc727163a16d0bab000"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8942b8aad05bc028a9e44914aa0cafeeea00d7f9146d660501e8b030fae0e6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cb5a2e6397d1c379725ff15a9fb16a2517a7631b39be011a3d64f199b55479e"
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