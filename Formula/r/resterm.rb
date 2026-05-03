class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.34.2.tar.gz"
  sha256 "f302a960572cd76ef539bf8978b69e0c4623b8466b951e6bba7a4c174084bcfb"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62dfc415a3e27b02672099290589737151cc6cafb06730f0e819fdcb7fe42ad1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62dfc415a3e27b02672099290589737151cc6cafb06730f0e819fdcb7fe42ad1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62dfc415a3e27b02672099290589737151cc6cafb06730f0e819fdcb7fe42ad1"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e33cf9660fbe3ae7cbd647ffbed10456cf63d02bc539e7b2a9798966b85b0c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d07c94edefdd22d5ad9e33b803cd88d96335f8bf6b2d8adddd9ee79b7840d8c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d066daf0ed8bca4194865c8a208b6d7d99fc43f1bd6752d468c0f31ee15854bb"
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