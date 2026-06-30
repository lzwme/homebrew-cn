class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.44.4.tar.gz"
  sha256 "b7ea56e8ff8f90d27a1cdd818006be7089667e8aa4d669e4407a096bb0935b16"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed5ed5e0c3eb1e31b8733312867f09aac920c274954fdcc74bcdfee5a49df5e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed5ed5e0c3eb1e31b8733312867f09aac920c274954fdcc74bcdfee5a49df5e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed5ed5e0c3eb1e31b8733312867f09aac920c274954fdcc74bcdfee5a49df5e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7e4b5c0ad7c6b8a539907f7215e6634bffed7556561802f4ed81cd86bcfa437"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a4de3f225e8fa7a29349560b6ea44ace0eee9e48eb23c4f846c52a099dee7ff"
    sha256 cellar: :any,                 x86_64_linux:  "e3fff4f764b75acf5c19e7ce21f48f352f20d6f1320590eb0d5dfb40cb3965a7"
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