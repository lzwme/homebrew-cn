class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "5d6fc6056d03c0eb05dd94375ac4c9e3a6beb214ff7d54da5ebc8ae5087a66e5"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0ac774d57ea912ecc3cbe24b31b98ac0881990754fd437f24d80d9342c014437"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0ac774d57ea912ecc3cbe24b31b98ac0881990754fd437f24d80d9342c014437"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0ac774d57ea912ecc3cbe24b31b98ac0881990754fd437f24d80d9342c014437"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fdefe8af87e8c02f3a0fffeb0ed3db178cec041a90aaaf85d8de46c36d780896"
    sha256 cellar: :any,                 x86_64_linux:      "56723584fc3b1b35d1eeee165081971bc00bdab6e7d013893a711d81cba9a824"
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