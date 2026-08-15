class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "4c65c209e84f4186eee2b585fb2a9ce90c9e1cca5478dee479908c9486a5295b"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33b6d40e74c958a700bcf2571735f5028ead66dd68f88e53d0e171b3cfb60f2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33b6d40e74c958a700bcf2571735f5028ead66dd68f88e53d0e171b3cfb60f2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33b6d40e74c958a700bcf2571735f5028ead66dd68f88e53d0e171b3cfb60f2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "821e8151cdb0c13eeee09ad80e064e3e22e7525582959ce65530427e370432eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72c122362de55813479eec35a418b56aa97fd0ad95441748e8588a0235dbf6c1"
    sha256 cellar: :any,                 x86_64_linux:  "006f974fe173ed17fb9251f6ab96364e3ffc17080403acfdb93c610c47664dfb"
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