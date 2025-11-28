class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "4a89e583aabf6429061737ed1442e0eead1e7630f9a7bbccaf6eaf9ca8f4f425"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b363792188bfbdedf19e0fe7cd035f886e00f4e8a8b7d9ba7abbc3a0b2e7ce90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b363792188bfbdedf19e0fe7cd035f886e00f4e8a8b7d9ba7abbc3a0b2e7ce90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b363792188bfbdedf19e0fe7cd035f886e00f4e8a8b7d9ba7abbc3a0b2e7ce90"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0d7eea48efff90cc936a39091e9e0ab3f3bf17b085fce3264b9979d9113954e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ceb99d1b223e9dc899b19194e43ac28864823dc732b0c5ac17a9883fa1d1565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccb382be685f86f7c22c37a8c0557f38e40d41a985462001767420df2698cc26"
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