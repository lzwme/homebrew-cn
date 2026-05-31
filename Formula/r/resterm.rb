class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.41.1.tar.gz"
  sha256 "0185dc7206af132ef2fbd39527cec4f99615848f16443427532e68634ef05a78"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb5ad61eee41a782f957566df9746f07b1b125f6f5ab7db50e6c51d6b481bb2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb5ad61eee41a782f957566df9746f07b1b125f6f5ab7db50e6c51d6b481bb2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb5ad61eee41a782f957566df9746f07b1b125f6f5ab7db50e6c51d6b481bb2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "283864c8a95ef81828f709520b783cb677e93348172dad017b35be9470236a87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d18c4dc07fdbdc1c088fdd840772da8db834352c5b85e28856b0b4fd4aede06a"
    sha256 cellar: :any,                 x86_64_linux:  "16f0021264790351fcbef6f538788efb265702c74bb2cb86b636b834bb93eb1f"
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