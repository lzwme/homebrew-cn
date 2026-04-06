class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.24.3.tar.gz"
  sha256 "6a0ab7f8b04861de017c0809cae39e32fc3d184c5c08fe953fc20a1a8c7c7a4c"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8eed6c642b09ddd23abe4e01c9c5c5650c0f72dea41b645d5c037e0fbcc5667"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8eed6c642b09ddd23abe4e01c9c5c5650c0f72dea41b645d5c037e0fbcc5667"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8eed6c642b09ddd23abe4e01c9c5c5650c0f72dea41b645d5c037e0fbcc5667"
    sha256 cellar: :any_skip_relocation, sonoma:        "d67571709060efecbd93056c35bc84418e17c6c48a5ed1ddec50f78049d16fe4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4625b9b685bb26496fe78a97a2ddcf8b726be032bece03952967da328a85829"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe823c9eae2663683c8bd9748be6b0d0f96d746ff99e1f8a26f730e6a442550a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/resterm"
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