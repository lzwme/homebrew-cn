class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "f0824676bd593fc96d46817ace86585a05dd8dd32bd7048da70202216ca74fc6"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f64a0ff9bb15d0f6f6fadd73e995b5caf982711b342686ba800cca5ea602c290"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f64a0ff9bb15d0f6f6fadd73e995b5caf982711b342686ba800cca5ea602c290"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f64a0ff9bb15d0f6f6fadd73e995b5caf982711b342686ba800cca5ea602c290"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "51af45c13ab06a529c1f0640287c6787b6adf947892bd7b7129164ed79fb19fc"
    sha256 cellar: :any,                 x86_64_linux:      "8352098e5640e4890af7e70e95546f739ef6219fa1c367dfbbb7d3603a33e1c1"
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