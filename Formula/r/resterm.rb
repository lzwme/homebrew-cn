class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "b2361ce69460f197bf4b6c73c84ca8c98214b957bd77c34796e5e9a1e98575dc"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab651d8fea4ee42f5f88180dbe2e804936cf005550cd4009da84b8a8422ebb6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab651d8fea4ee42f5f88180dbe2e804936cf005550cd4009da84b8a8422ebb6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab651d8fea4ee42f5f88180dbe2e804936cf005550cd4009da84b8a8422ebb6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f398cefad119024c21ab23920fe94a8e3358c9cbdca9274ce5518520dbd8280c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edece36801ef90b916acd212a6acb2b12cf1b726648cbd3b43302b9d4e1f4dc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4564cbeb6bda056da7932c9bb1bb2c62fe7f7ef40a6c4cc790bc65216369d3cf"
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