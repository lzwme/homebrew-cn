class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.44.6.tar.gz"
  sha256 "17640f6646b799e9e7f11469f74a4af796aead0796a78ec58247dac51aafbda0"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2aacb0d8dafd92d37b5304a0fb12ff42fcdf1e549e967b2ba41c67be1a66ffa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2aacb0d8dafd92d37b5304a0fb12ff42fcdf1e549e967b2ba41c67be1a66ffa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2aacb0d8dafd92d37b5304a0fb12ff42fcdf1e549e967b2ba41c67be1a66ffa"
    sha256 cellar: :any_skip_relocation, sonoma:        "4227365b3476506d72fc99b8093253ca342dc44d6bb0bb7b1f007177cf6a0878"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11bc0c0aab710a3a5adbf236989be77f4f0b1c49fe54e0f34e5b5462c10c8190"
    sha256 cellar: :any,                 x86_64_linux:  "4c3daf6960f3a28c0b3ee2dbfce65da3f4b2c8df8df662829c1702aa374d3061"
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