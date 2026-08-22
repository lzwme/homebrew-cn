class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "006a865b60bb67d268c9fcd7101617cf295a627826180d862fb237665ef58562"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c606a45151bc7d7209719fc87e4e68996b6527d87f9a42f7aecf43abf8323483"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c606a45151bc7d7209719fc87e4e68996b6527d87f9a42f7aecf43abf8323483"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c606a45151bc7d7209719fc87e4e68996b6527d87f9a42f7aecf43abf8323483"
    sha256 cellar: :any_skip_relocation, sonoma:        "5699b133832f7e5d05b06a4f7cf1413957bf911742333a1cd8a8fa3855195609"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c99cf658a9708a48a112471421843ce28a12c206acfe6cdb95b984d609f25409"
    sha256 cellar: :any,                 x86_64_linux:  "7e660966d7849c683648f8af10071d0d7e25b8a7ed5b40e50d50273ab01ebafa"
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