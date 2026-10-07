class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "2917418b9e925a3cb69d6f69d742211976ed2243d5fa700a7d7cbf56b9d7bde9"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "62044f3e595c66632fb187af49b039bb7b64783db298b837a7c7a6c59ae1c453"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "62044f3e595c66632fb187af49b039bb7b64783db298b837a7c7a6c59ae1c453"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "62044f3e595c66632fb187af49b039bb7b64783db298b837a7c7a6c59ae1c453"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "86aca3584f68665c6ff2da865b471a976e0645c983a77052a54ee4c42ff41abe"
    sha256 cellar: :any,                 x86_64_linux:      "806984ff793efdf4844abd1a24863d573a71d853d9cdbcc5dd648cdbf36e20a3"
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