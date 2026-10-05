class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "19202d50f264881a896466e9c3b1b9ffe7973d130a12de7cf53a342c516f33bb"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1a441463ced8e27e0927d1cda739c6d49051f91fe248383258c7f99e972e86eb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1a441463ced8e27e0927d1cda739c6d49051f91fe248383258c7f99e972e86eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1a441463ced8e27e0927d1cda739c6d49051f91fe248383258c7f99e972e86eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5d4f56c8791adf52a317c2a77017428104ddc737d077b67c3d36ff99ae78a115"
    sha256 cellar: :any,                 x86_64_linux:      "ca912c3242486aa2002db00683991ccc27438ca5387971b4a969a538aa2db3b0"
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