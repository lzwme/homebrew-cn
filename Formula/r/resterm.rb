class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "eb128f23f5efae52c1a14917aa0b67109e09a6c9ec7b600c5762308fad28c9ff"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07f039643af80396bfc7867d0361ff9e5641d759792a2c5dafc309f35ab468e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07f039643af80396bfc7867d0361ff9e5641d759792a2c5dafc309f35ab468e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07f039643af80396bfc7867d0361ff9e5641d759792a2c5dafc309f35ab468e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1f3b50a9a2205cefc1455f6ada296c3ef9e9ac348e260231237cdf158762557"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3347df435be265268db9e3ff0f8bbbead25746357787272dd94353fb00361514"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f96ed7e1013422cdd344d0449862b74b812d59947476ef405eded1ff1dab5992"
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