class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.21.4.tar.gz"
  sha256 "bafd88731e8cc653fa9cd8aff585f19ec2b0dbdb02b8f09f0cdde26e130fc1f7"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2228f0b659bfe21524518589342315c3f7d8d8c6f440161377bb8790740259b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2228f0b659bfe21524518589342315c3f7d8d8c6f440161377bb8790740259b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2228f0b659bfe21524518589342315c3f7d8d8c6f440161377bb8790740259b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d2b9971a7fed855044d77b47539b6b620b9326b319f41900b74669da4d10ee0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7506cc19c71cd6b836b68ff0b867d611223e0e999dff8e92cad83c353f41a6df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ad5879b6c83cbb9979674355a195c17aa4f23217af12c93c5b2ff978719902f"
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