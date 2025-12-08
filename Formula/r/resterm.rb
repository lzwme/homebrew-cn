class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "27acbf568b78e8969ffaa12df6ef8a9dca64bbb7366b27bcc37d2058ddd33cd6"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f04a77ccb94833f8557e1477f279379a17706b9e909314f255853fc03d82ca87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f04a77ccb94833f8557e1477f279379a17706b9e909314f255853fc03d82ca87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f04a77ccb94833f8557e1477f279379a17706b9e909314f255853fc03d82ca87"
    sha256 cellar: :any_skip_relocation, sonoma:        "f26b716a8c33d1fe198bfc3dacff71758b73ec1b9a9a1aae891275832d40cd20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "613e3acee58269087420f4abfa14a0ba134be81365b1e77ea669d11616765ade"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62755ce4e58f9076c5da472be7d25539425c0e392a0c692e9f0e85af2adc5745"
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