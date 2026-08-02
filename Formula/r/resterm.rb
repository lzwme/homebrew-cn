class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.49.4.tar.gz"
  sha256 "8a26922e5fa4f2fc6633c6b8714e723e8c6434a895651dbb97e36b293b9379bb"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "710deef3b699ba4c8516d4776536970239eb358dd3fe01fffab0f2e21c8f5a32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "710deef3b699ba4c8516d4776536970239eb358dd3fe01fffab0f2e21c8f5a32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "710deef3b699ba4c8516d4776536970239eb358dd3fe01fffab0f2e21c8f5a32"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d0e824615d64859281653de5cc7ee6f011e7e63949f885311692a99857a179a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eca0c8249aa516f6dff2f603725c8922e2a61c9ac14a7e5dcb81a2f5b19bae83"
    sha256 cellar: :any,                 x86_64_linux:  "2ae33fdb695058eea3846cd28834c4ded563b7477c6869ba7856658ae29c9f04"
  end

  depends_on "go" => :build

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