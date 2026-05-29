class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.40.1.tar.gz"
  sha256 "1f8038c80e9855c55451b434d6ae6e2bc79767486f418d93a21c7b2c7786c836"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3417e1263b5f22aad672140fdc5944c3c44b5e16046d3a745d718a2f2a259a2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3417e1263b5f22aad672140fdc5944c3c44b5e16046d3a745d718a2f2a259a2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3417e1263b5f22aad672140fdc5944c3c44b5e16046d3a745d718a2f2a259a2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e51b2a67cc83014cb59830eafb35639701d5bd09a4430cc6da7841f2701a005"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d7604f286eb718e0eef8922030c11da0a73928af6f4b50fc465bad02e70dc21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "372adb2505f4b43ec7afee7d068305b1c16d414506a6bbbc44d92f9ee090f52c"
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