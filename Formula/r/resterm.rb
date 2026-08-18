class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "32f0be2932f4806682002697cc3ef97c089d3d7114573a3d4b7ca6186e3977e5"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de62cf82bb5733d6c49827a626bfc3aba63f7f3d06f60e0eb7764bdc9e9fc76d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de62cf82bb5733d6c49827a626bfc3aba63f7f3d06f60e0eb7764bdc9e9fc76d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de62cf82bb5733d6c49827a626bfc3aba63f7f3d06f60e0eb7764bdc9e9fc76d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d73420d780ef54b1b4708d988f2e3c99706ba0c3c7ff7d770ca4eb5a47e9c61b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a764d273b9af03e50589c9c7beafe8f8622a2c37eae285d20c321a7cb40af61"
    sha256 cellar: :any,                 x86_64_linux:  "c8a53bef1d2e84a14d6cb2c230c10c53596d30e43aed059602b74a609992c237"
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