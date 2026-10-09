class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.13.3.tar.gz"
  sha256 "179d56cd24260d18952edcddb08a006553274d817a349937e023b31bdf8b8f85"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f28314e43ae4eaf6b8b08796cac0a31f06f76a07d5d3dfd9b2efb2d7154454e3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f28314e43ae4eaf6b8b08796cac0a31f06f76a07d5d3dfd9b2efb2d7154454e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f28314e43ae4eaf6b8b08796cac0a31f06f76a07d5d3dfd9b2efb2d7154454e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8a56012035876a53765829f07e62a40074e6f3833724ca1f3e9f1342dd1a7b5a"
    sha256 cellar: :any,                 x86_64_linux:      "0fa55edd3bdac6ecd62342cee50f656959567ece5bd38e0fd6ba3b696ae96d49"
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