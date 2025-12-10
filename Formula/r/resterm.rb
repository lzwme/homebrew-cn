class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "9da224c94be37f6f1f557ce1e4121c036bedc8119f449c2be202b5f33b872636"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19a19f163c2a3a406cb373f343251a96b7d95fdc59ec948506859449fb91bf97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19a19f163c2a3a406cb373f343251a96b7d95fdc59ec948506859449fb91bf97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19a19f163c2a3a406cb373f343251a96b7d95fdc59ec948506859449fb91bf97"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3a8cfb0de4b58471c016e58e3f9e125e05cd24962fb66fd8378ff3cf79caa4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74806f3b778010c7675bdf21175391a5c4c4fa28ffb079c8ec93e6930a0aedd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d933daf054509426283725418f6be69acac72cc082c271a8b8f859e5708d18e"
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