class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.34.3.tar.gz"
  sha256 "ecaf55912e39a6c81cf3e74a5d3f5ae78a218329c5f1a3ae14b422c0a515aca4"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e86943f2cf5f183392b63237fb35a6249e6a04cff89590b1a2dd1b600ae4811d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e86943f2cf5f183392b63237fb35a6249e6a04cff89590b1a2dd1b600ae4811d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e86943f2cf5f183392b63237fb35a6249e6a04cff89590b1a2dd1b600ae4811d"
    sha256 cellar: :any_skip_relocation, sonoma:        "08dec39f16f82d82a02079b85e896cf821d1213bab6f70b6cf6c9ce4713fc71d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7150d21e677d138c7bd31fa00943f5cf1adab217d7fcfb9734c27fe8f2bb4efb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd0fe2bd102b5c5d719a52e0d0edd9b49c9b3f3c716e586bb1b99bed333caf7b"
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