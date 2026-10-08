class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "e3187871c9c5370f3bf1a70d8dad290ea9c25377e2fd4ab345eb1db94faa6bef"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6d5086c6881bb1548fe672c0d0df6aaa95bfbe6cc30ac7604295c01a06def723"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6d5086c6881bb1548fe672c0d0df6aaa95bfbe6cc30ac7604295c01a06def723"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6d5086c6881bb1548fe672c0d0df6aaa95bfbe6cc30ac7604295c01a06def723"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "263b9cf4f71bbfc4e5c9ae04a82164709bbdf63a9e393d5ea60657fdaa46e9e9"
    sha256 cellar: :any,                 x86_64_linux:      "00d5b7441a6aa222f0352f9d36f93198de230b71948acc0961d7ff4ad75b8e2d"
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