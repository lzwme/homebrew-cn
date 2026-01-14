class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "3c592f56024e25e71cc64dd78d2dc094c93430afd76739986eea86a971549569"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "467a09b3500dce70e1d097b38a3e2bec0358007f47b293a6f8ad5e2189f95d26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "467a09b3500dce70e1d097b38a3e2bec0358007f47b293a6f8ad5e2189f95d26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "467a09b3500dce70e1d097b38a3e2bec0358007f47b293a6f8ad5e2189f95d26"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab13e9f0cfda67e8bd3c5055775a765615b053dd4dc39bb2065d796b8d1257ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6ac0ca962e6568e3155113e41a604dfdf1835b9f53790dda476b2ee385176b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "393204bf4245f9b284f8cf970454662a95df62585155e27e836441d94f75bb2e"
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