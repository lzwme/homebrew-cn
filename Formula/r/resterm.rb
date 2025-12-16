class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "32d5016e5334858fe05796ed31fc7bd9d7f11823ddf7dcc0dac41c4303b3ec30"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0fdc3fc86629991ac49e373f016106d2ccfcac57bf583b7227196b6f387af1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0fdc3fc86629991ac49e373f016106d2ccfcac57bf583b7227196b6f387af1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0fdc3fc86629991ac49e373f016106d2ccfcac57bf583b7227196b6f387af1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d00a65a2bc2c2b2259ed84334ed9ab26adb5a71e05589550bbe447a8718ace6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88e2d35bd9798a8891f6dcce9cb4664fa236cd3d3ef0f15ada4c68c977f104f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3699f4f5144e88fd0b30a5d6f43174409646ed6d54f7e35cd30cdae51d965c7f"
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