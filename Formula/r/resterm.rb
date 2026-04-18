class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.28.2.tar.gz"
  sha256 "666320fe78d21b372d3d1593dec3e2863aea1d112c8ec0c65e3592ec395b5022"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94ca8f55c1eaa293aaf224f635b461cde7756956a6c781f736372c49796c478a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94ca8f55c1eaa293aaf224f635b461cde7756956a6c781f736372c49796c478a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94ca8f55c1eaa293aaf224f635b461cde7756956a6c781f736372c49796c478a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c770dd6f79d9ebc7be9205243427d3700639226262e044873c213cad80ee0c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a7dc1ab09b77815fd7291b84174452cbeff76ff6d2f79cacd4ff81bcdbe2efb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b0a1527360ba5851aab40e4b9288bf8c04b4bc4eccb2879f8ab4793925bceef"
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