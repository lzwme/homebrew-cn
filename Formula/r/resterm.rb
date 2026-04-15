class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.27.1.tar.gz"
  sha256 "a0e1fb2761ecbfc602ca7fd48dafbdf912646cfbceaa9fb6de1d5f9a14699bd2"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98ca20c19e888414fa6f79a98716cf21d3878e1a6d0a47ae197bfb474e597421"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98ca20c19e888414fa6f79a98716cf21d3878e1a6d0a47ae197bfb474e597421"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98ca20c19e888414fa6f79a98716cf21d3878e1a6d0a47ae197bfb474e597421"
    sha256 cellar: :any_skip_relocation, sonoma:        "76c993a0405d8c3f2293f2d2d65933237238a444dbacb472160a5a321831c5d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e61adc9d9cb036fbbfbe24a346ff4d12c521cef07442deaca8813fbcf46f8fc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a21d4ceba697d08b76501c027efa0afeaf2346ad07addd9921340aa5759b856"
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