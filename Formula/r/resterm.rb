class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "73b6e0013587a7c9e90242c71d68943b678f17cd785db3bf1d9cec1b5e44cae6"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1878ab8d13b8220cd2ae3309bbf628d8195aeb827bdfb7c223a7f3cf3692a8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1878ab8d13b8220cd2ae3309bbf628d8195aeb827bdfb7c223a7f3cf3692a8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1878ab8d13b8220cd2ae3309bbf628d8195aeb827bdfb7c223a7f3cf3692a8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa478d67ad283959a4d5e0b6cf8090c64840273cc73ae217449cbb35c82a9abf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09883d466f5ca0530284132e1c9e5aed52a718ae7886fd992c130f26f20caacd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4014d23b94ecdcd71c3394a066fa4b8342a65252332a7318f97c3761b7aaf9b7"
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