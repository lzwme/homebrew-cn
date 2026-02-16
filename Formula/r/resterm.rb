class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.23.1.tar.gz"
  sha256 "77f9f1cef00f347e8590c98ef90f7398159d7b259cf415658bb227951b2f474f"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5647d992df415dedbf65473d79a779e5bd609f9ff6218bef58b977dcfc967333"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5647d992df415dedbf65473d79a779e5bd609f9ff6218bef58b977dcfc967333"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5647d992df415dedbf65473d79a779e5bd609f9ff6218bef58b977dcfc967333"
    sha256 cellar: :any_skip_relocation, sonoma:        "13f22c95ddadcc6e7b1f9d0bcb72c72f81b7ff0bdd81f3e4065472c5546f0c72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7458ce50f867e30c9a0ab81511ffdf3254d3204ee06ec539f0cfca36e8467354"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17581e7e526a84405d23224f30fabbd638494237c3a6afe2a1ccacae7bcc7785"
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