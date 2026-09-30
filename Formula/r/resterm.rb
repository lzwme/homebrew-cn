class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.10.2.tar.gz"
  sha256 "c9dd34fd33a243ecedfa6e885e4e7d63d9fda259e5347dee6fd7c26629ac29e3"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0a50e74bc97df931c9c2ee8162456d4c7e93b98707d697c107312b57c5b82661"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0a50e74bc97df931c9c2ee8162456d4c7e93b98707d697c107312b57c5b82661"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0a50e74bc97df931c9c2ee8162456d4c7e93b98707d697c107312b57c5b82661"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "128e5dabe2bf0bffdc3f7a10cf7f691d12fa703f097851015a1a6e9f83714ed8"
    sha256 cellar: :any,                 x86_64_linux:      "e86df9b5250381bbb6c021224a92025dc3a492597cc7e9652370dd7500efa55d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/resterm"
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