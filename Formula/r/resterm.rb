class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.39.4.tar.gz"
  sha256 "04351e2dac267449655aa18f58a3a9c45da10cf309772ecdedb905a750903b72"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b85a609ae0565ecb9aaecbc88d18408456f654ad8f819fbb5ff2d59e0ef45ec6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b85a609ae0565ecb9aaecbc88d18408456f654ad8f819fbb5ff2d59e0ef45ec6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b85a609ae0565ecb9aaecbc88d18408456f654ad8f819fbb5ff2d59e0ef45ec6"
    sha256 cellar: :any_skip_relocation, sonoma:        "89e601bb86474a5c24f651dc9bcadbf863765825d61d4da336bdf2b8e4824ea9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97e8a4e69f89dc6e7d64302f3a5fd0db001f0fcbe4099d591b11f77884dd2006"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8188fc99972764c797d3428e1f9968c022a392a93cd5070517d867386713d8af"
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