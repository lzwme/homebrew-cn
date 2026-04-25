class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.31.2.tar.gz"
  sha256 "7ecbefed818c6b33df1f86aefac859642a74dd52c645148dcde87096c2ccf755"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33565e3e62d19345243ca46b1e8aaee4a7f52a4d3a74b0e7626bc46989fdda55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33565e3e62d19345243ca46b1e8aaee4a7f52a4d3a74b0e7626bc46989fdda55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33565e3e62d19345243ca46b1e8aaee4a7f52a4d3a74b0e7626bc46989fdda55"
    sha256 cellar: :any_skip_relocation, sonoma:        "e90a2d28d9794060432bb7bfd9253a1ee6e4b9091e0b10ac9e01a581d8870242"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5a231ce14a4d3a06cff4d103fc9bfe1724f69a5e2cfb4ac51220d41bf8daa4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a320040c8dcccb94486efc3dc87ae48bcbf72f1cbd9d1e95e8a9b0f86ecc94cb"
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