class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.24.2.tar.gz"
  sha256 "4a014b3a080d6099ce60b27be1bdf19b172e869c4b9be7748b02eec5440c653d"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7845287001e4f80e5fac2174f8b2959d537b3cf809692559410a32d3f047771"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7845287001e4f80e5fac2174f8b2959d537b3cf809692559410a32d3f047771"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7845287001e4f80e5fac2174f8b2959d537b3cf809692559410a32d3f047771"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b0fd4657c6f6f14d08001827d02066a30c118916c1899063a8f7524a59b05f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab264c91e3b692220c3370aa6702361b16b1e4400b2aeb7b3922b2510dfce99e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "974fa74af7bfc854643ecc4b0e2006f09e1625287a72f7df32d3faafdd712fa9"
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