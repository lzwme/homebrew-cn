class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.48.1.tar.gz"
  sha256 "705a3a48218df4f18508361bb818b305ffb12c4305a1e5157c12f3e345760f20"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e6d101548742ec88f659cdf1540bc491051b6ba31e1bbd61dc26f8071dbe481"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e6d101548742ec88f659cdf1540bc491051b6ba31e1bbd61dc26f8071dbe481"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e6d101548742ec88f659cdf1540bc491051b6ba31e1bbd61dc26f8071dbe481"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5e53ec129c28297aa54c19d3699e1d1c1710e61af5088e0164f0c19233bbd8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "973834e59a7129331c99a5171e9e621a98e52dad1aaa26776e5a0a6b440622bd"
    sha256 cellar: :any,                 x86_64_linux:  "204edaa541fa0646645d15d6971f5af1f113dc17cb43060c39336b0cefe6d2fa"
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