class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "48a259b9e644a1e6881e457455dbf5d452c4ea146d454d237ba3fefbe74c555d"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cda9e1020fc697cc60ee587d54e5d209a29d56979aaef079a02de3aa417cdd70"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cda9e1020fc697cc60ee587d54e5d209a29d56979aaef079a02de3aa417cdd70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cda9e1020fc697cc60ee587d54e5d209a29d56979aaef079a02de3aa417cdd70"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e702cb08483c2931d6dd1816d4027c254565acbf6fd1f7b8242da24259e39105"
    sha256 cellar: :any,                 x86_64_linux:      "ffd765edbe62f57bbf8fea9729f6cdbfddc1af482a593b8c967e816cea2aa8aa"
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