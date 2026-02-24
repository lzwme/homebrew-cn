class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.23.5.tar.gz"
  sha256 "c34d40667852f04ac8bb1883f2c59f2a3cac6565400308f0b6c6a75d7c74db4b"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b05cf41f89ad78dfac59854210a21b43f8d54da2f34f516b86a5b0785fcc8530"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b05cf41f89ad78dfac59854210a21b43f8d54da2f34f516b86a5b0785fcc8530"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b05cf41f89ad78dfac59854210a21b43f8d54da2f34f516b86a5b0785fcc8530"
    sha256 cellar: :any_skip_relocation, sonoma:        "47ffec2f563ac8e699a488ecc50de7a449598a89e07375d6577b672a17f4167b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ef83d0ccc37275913dd151a3e6824f910ee64d78da2aea843782d1cad84bd88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30091af42413f4108507bce432f1a2c2fede46b2a87e270fc9254779e11b23ae"
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