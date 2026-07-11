class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.46.3.tar.gz"
  sha256 "a46b672606e518ebd8a687ae92a2170dd09064e53c66315cc1ef9c2c80ad535d"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d018d19001012aa546100c5ff63514b9b2e059b6253e4715549fc516089fcd1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d018d19001012aa546100c5ff63514b9b2e059b6253e4715549fc516089fcd1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d018d19001012aa546100c5ff63514b9b2e059b6253e4715549fc516089fcd1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec66edbe8d9e6634e20cd283cb48f7aea7818e92beb3e7b86440363b0981f590"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a9e3720b1bbe90e7e80d05fb2780e3751e33080ed61962f986de02fb8bf0572"
    sha256 cellar: :any,                 x86_64_linux:  "97c92ba01d2b0adaed913a20f86bec7c9c0f2cad6ce15c5ff085633a0a330263"
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