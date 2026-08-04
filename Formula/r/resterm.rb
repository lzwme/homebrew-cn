class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "d85fdf1e1a0c5235b82a203ad57b48c1f89d6d6f447c0a43bbdda64e5151528f"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c3134a90362e899e547ed207e550bb2459f68eaa7c824de9c8b544285fcf083"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c3134a90362e899e547ed207e550bb2459f68eaa7c824de9c8b544285fcf083"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c3134a90362e899e547ed207e550bb2459f68eaa7c824de9c8b544285fcf083"
    sha256 cellar: :any_skip_relocation, sonoma:        "883f5e3236591ae9e3c88a804fd3373c7d5c4aff85262f1fa3d90e426d380396"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5af9e58ef80cb028b69e4d2ff17cc3b9779d29cff1152a6420ee9c436434e67"
    sha256 cellar: :any,                 x86_64_linux:  "710b99a91ce5c5562b9479c16dbea2b11953cbd7a0a3e72a499b406519725646"
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