class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.21.3.tar.gz"
  sha256 "b31dfee5c4331c59e6ac58308617436ccdd99c768f08b587e546f0684a7067e6"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4689af3cf1e32c76142126ae282fd6821ac8c66803d9ecc8743245ab2bccc2dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4689af3cf1e32c76142126ae282fd6821ac8c66803d9ecc8743245ab2bccc2dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4689af3cf1e32c76142126ae282fd6821ac8c66803d9ecc8743245ab2bccc2dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "6aaf3878e4157b710db5f41f4228d11874bcd5c39033cbc91ae2b8cf5f30789a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88d2c1c8d6831805d5cb2897a3d4cab002a9b6b6a351101710c256c81d7d38ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ce1990835c5aa5149289ce6228f0925955f33ef5c806e09ee10767baa3fdb71"
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