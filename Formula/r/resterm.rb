class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.51.1.tar.gz"
  sha256 "05b71bd38d4009e51adbda5e5356e0a73078eec22c5abb7e6f6eab11ab4a33dc"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ae36c91946b3c54ed0e99c4d1d48fc272d5f1a45c8fb04f19c33fb210574140"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ae36c91946b3c54ed0e99c4d1d48fc272d5f1a45c8fb04f19c33fb210574140"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ae36c91946b3c54ed0e99c4d1d48fc272d5f1a45c8fb04f19c33fb210574140"
    sha256 cellar: :any_skip_relocation, sonoma:        "d484869065fc106edabbc8062ee0e47e85acf2b7c9e05ed52a73774ec4a0bd0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2978316decdf193c68c22fa7cb8db77980a94fd2e963ac53ad699062cbd4d7e3"
    sha256 cellar: :any,                 x86_64_linux:  "f194d754318a56959ff1c91c1daadeed66826991d3311b7181b0c6bec164b13e"
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