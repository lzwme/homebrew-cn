class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.11.4.tar.gz"
  sha256 "b595ad18d1463a61f56e5452129c1becf900a12b1f8fa789b453afa64c473726"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fb2c11219d17509141ae723a3373bdcb2cbc5c35b9485de6f904b647590295e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fb2c11219d17509141ae723a3373bdcb2cbc5c35b9485de6f904b647590295e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fb2c11219d17509141ae723a3373bdcb2cbc5c35b9485de6f904b647590295e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ee42d44cba74178969d57854bf3e424f95199ed3bbc8a3d6a8f594a8688455f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38773e4c27c86ae07c20f6e744b91e0540c2c8746cf9b703f42393df66256365"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45e3dded0e9089031a5fb23028c89332c52b9830ffa7334cbb91586aa731df68"
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