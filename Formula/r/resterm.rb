class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.30.3.tar.gz"
  sha256 "f4baba30818af53df3555bb05e78ab3b90f451e0947356948c969d6766709290"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f657bc36f55dbdc9ad0a3324a4fd7ccceb69cc252f0c7b840b04a87f5a70913f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f657bc36f55dbdc9ad0a3324a4fd7ccceb69cc252f0c7b840b04a87f5a70913f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f657bc36f55dbdc9ad0a3324a4fd7ccceb69cc252f0c7b840b04a87f5a70913f"
    sha256 cellar: :any_skip_relocation, sonoma:        "87fa5148df9d1714a08cda1d4b1fd9ae2eee505d73b2cd717070fee3e00d2d77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccdfa49f0f3e6df1c5d74c47b7c6c27dab6a45ebe43a157909d61e9f8c8b2613"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e5e55b5844729306e0ed58817a04fb945d786b1c01bd7b8db87376e4415d155"
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