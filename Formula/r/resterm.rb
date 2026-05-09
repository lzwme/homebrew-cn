class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.37.1.tar.gz"
  sha256 "57e44ac2ca85054d47dba572b459a6ca3daafdb8e8d259f43a2aa55eebbc01c2"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb99ae86dd60b9f045856e0aebe661eb8d2270f6aa70e6328a6285ae6b92de15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb99ae86dd60b9f045856e0aebe661eb8d2270f6aa70e6328a6285ae6b92de15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb99ae86dd60b9f045856e0aebe661eb8d2270f6aa70e6328a6285ae6b92de15"
    sha256 cellar: :any_skip_relocation, sonoma:        "e40587b428ed1d6eb3722fb5cc351b9959507b08a7952a3a5b85f7719497017c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b361335692e6a7daf2d5694a8cce2c783ef148268e74c6c94b190e6a4d863dcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "274f0a1f8fc9f6478b138524929700e585bdcae6731ffa2ece075699589293c8"
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