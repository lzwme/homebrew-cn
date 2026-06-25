class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.44.1.tar.gz"
  sha256 "285b609c81dcf2359ddddea637a0d52bd4261442f08c2412c21d4ed74c2e1e26"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f8496518e0ab737d85974e6320d85f6aacc530b92be568f036c515c342b7308"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f8496518e0ab737d85974e6320d85f6aacc530b92be568f036c515c342b7308"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f8496518e0ab737d85974e6320d85f6aacc530b92be568f036c515c342b7308"
    sha256 cellar: :any_skip_relocation, sonoma:        "901737be587fa20e07c69f3868122eac9c44edb629664050e4761f2b7629cd9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e11bfc1c6a4d5bdda1f36a49cf6e8439155a07ab672046aa4d4c62b9c7ccd20"
    sha256 cellar: :any,                 x86_64_linux:  "b6b436714f3b7341f315cb69bbbbb3d4c297c31e85d8fa829c548ce417945f12"
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