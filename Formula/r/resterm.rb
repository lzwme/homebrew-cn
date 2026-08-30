class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "209bf6ac9d308d9c97696b32a7fb057b41bf0131e3b42bb86dfda122c6b846b6"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fd875901172a275d8192e2371aa5b73baff8ec79210a75645edbe1010352712"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fd875901172a275d8192e2371aa5b73baff8ec79210a75645edbe1010352712"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fd875901172a275d8192e2371aa5b73baff8ec79210a75645edbe1010352712"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a47c450fe4b6e8c5a5d90ea564dc3f2c53d96567a7ecaa78ebd84b22eb9ff5a0"
    sha256 cellar: :any,                 x86_64_linux:  "042ae1d0ee5dec1798728d12dc8cde09074afa8173361978d11852325a5d8e9e"
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