class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "a977de950f1a9115f62b4b49f9fd09868319f924af7274d99e1ccec62f067510"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73ab27c26c092e3cf9e0ef75df8198c2366ac1b3795a0f767058d56415496274"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73ab27c26c092e3cf9e0ef75df8198c2366ac1b3795a0f767058d56415496274"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73ab27c26c092e3cf9e0ef75df8198c2366ac1b3795a0f767058d56415496274"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad048a877b89e9abcc7f096c028a787b6f82d5db7520288b71c3d5ba7813657b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "024c378cac641710e6de9bf2c570ec99edc3159debd9c0c45b878c3f08aae33b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0eeb6b9ee34130fb819ffd5390e75df7eb8f1e50addd4029afc2a819044361fe"
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