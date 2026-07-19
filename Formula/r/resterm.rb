class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.47.1.tar.gz"
  sha256 "e76d9a332afa928f06502085980f0d193c16fed9f36b81445cefbe17868ebc92"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54f8225b7184cda97027cf54fb87d9ab292aa13f2aabe792f5e887b5402346aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54f8225b7184cda97027cf54fb87d9ab292aa13f2aabe792f5e887b5402346aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54f8225b7184cda97027cf54fb87d9ab292aa13f2aabe792f5e887b5402346aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "9124e716ed55f3d1ef5b482a20f3c96659bdf5ea71d05d298873202c38805e01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddd66a7d8bc13b252de83441ee56caec38c53ed33ad2f16582477f7c217e135b"
    sha256 cellar: :any,                 x86_64_linux:  "5a8e3345d37af31ce4c65c47ed9f0e706e670caf2b5d581f49073639a1cf409f"
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