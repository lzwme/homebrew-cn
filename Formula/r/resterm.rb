class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "952dc3dff3a21242cdee7ed65e95178238d6b912de9cdd3cc18ad17945fa9b31"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f360d9c05e20f080afd11186202498f5159920f91092affbcda997a59c97fcd2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f360d9c05e20f080afd11186202498f5159920f91092affbcda997a59c97fcd2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f360d9c05e20f080afd11186202498f5159920f91092affbcda997a59c97fcd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "75cd7a89ce712341b25059947ac555e07926ab4149d7d91255c8a6ec12fbce16"
    sha256 cellar: :any,                 x86_64_linux:      "38c06e14156f0f89222eedabdcf31c560a90b1ad520786bfa8becdafeed14e47"
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