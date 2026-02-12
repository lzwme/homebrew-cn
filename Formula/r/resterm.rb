class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "7916319674befa0394b483f94ce7baafeea11fb6ed16643f56bb932e606ba3b0"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "081c7d00cdaeb7e6f501c57532639b5d5da39340c319e113945b8aa78be76cfb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "081c7d00cdaeb7e6f501c57532639b5d5da39340c319e113945b8aa78be76cfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "081c7d00cdaeb7e6f501c57532639b5d5da39340c319e113945b8aa78be76cfb"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f4e65c8c9c4ea2106be6f4d3e8dad3e841b06bdd90310e2c1b6648bdb3782c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea8e068ff0c54e870ebec5735972009b8c908313af9bd69b44d25cd83904b5e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d388a41904500cede04694f065920c87ecf0460ab266483107960df6daef52a3"
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