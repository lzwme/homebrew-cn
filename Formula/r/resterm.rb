class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.49.3.tar.gz"
  sha256 "279553691b38bf9cbb5ec0db4e83267f45107c18c8ec6d138358df39b996f5ce"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9472b091ccad57513ca9595ec71ff348f0f1cdf2d3206a11fcfd022610b65d47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9472b091ccad57513ca9595ec71ff348f0f1cdf2d3206a11fcfd022610b65d47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9472b091ccad57513ca9595ec71ff348f0f1cdf2d3206a11fcfd022610b65d47"
    sha256 cellar: :any_skip_relocation, sonoma:        "2516a9fc97c83b895befa0f168a38bb76b08f00744ae29bc1beb5eace202d5e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "331b7b51238f3950f242a4799783c26a80b7eed2b22424f34a9271776a380654"
    sha256 cellar: :any,                 x86_64_linux:  "a7f4c9c586a897c8d99cfc58cdaadb502ccbed4c94fe6fc5a09d7cbb76b34eb9"
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