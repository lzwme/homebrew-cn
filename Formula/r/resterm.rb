class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "46f2922c16d3ee109ff1212db7530353842fc0bb256ea92079434c0de70d83b2"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7674babf87b25d848ce3340484a0c96a52e875aa1f9f209191d752261d34f464"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7674babf87b25d848ce3340484a0c96a52e875aa1f9f209191d752261d34f464"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7674babf87b25d848ce3340484a0c96a52e875aa1f9f209191d752261d34f464"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4233f5f09750febe428cfef407e59064338521c0729e1988e7c0bc5b7463264c"
    sha256 cellar: :any,                 x86_64_linux:  "ebc09e3387b4b76b993febe302437a3097823ce23933f5aec6639a4465933c88"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/resterm"
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