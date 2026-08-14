class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "14900e4b6982ed7d95a147ad27eeeb0171d358a4eb8613a36e41e7f48548b8d5"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88196f2b8a95897727efe7b9492177b5f38dd1539b1a0a814f4c6db272ff4a50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88196f2b8a95897727efe7b9492177b5f38dd1539b1a0a814f4c6db272ff4a50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88196f2b8a95897727efe7b9492177b5f38dd1539b1a0a814f4c6db272ff4a50"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d8799381380f8b20d35c7c496e9b0bd7526c313b44b10f76262910ea6868a26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbf221bfcb3fcee3776cdf7d719b58d07c8fe76661f0e9588bef32dca2fe53b7"
    sha256 cellar: :any,                 x86_64_linux:  "f168bd6819591266e4340608d5c0944a2a4c70c2d5267543b9c536f12dfabc72"
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