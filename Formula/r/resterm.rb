class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "bde553eca366afe3cf663700588241661921f129f5b1eed13dd3075b4c348655"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e391f14a04560508c3fdb12cde725ed3897a7d23bc83a0262852056de898162"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e391f14a04560508c3fdb12cde725ed3897a7d23bc83a0262852056de898162"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e391f14a04560508c3fdb12cde725ed3897a7d23bc83a0262852056de898162"
    sha256 cellar: :any_skip_relocation, sonoma:        "8dc7d4f4c5bec636426a201d33b8d7a3a4981336d4255224971678645f1cdd63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7be19e0de6c296c8d663a73b1e5d1e5c906479cdf3f44484bafc201cb1521dab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d50361d9f8cca6ba2fdd201d9c6b0bf19debccf21c714a8618ed711c0b5e6498"
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