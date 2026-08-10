class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.52.1.tar.gz"
  sha256 "3d2c9b1ce82ea877d2d1e0ef7281b56c07aae0043f50f948ea91abeeb4cbf33a"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5e0d69bfe4854f1aa4176290eff945bf84dd7dd48646b6e4b57a3c82178747a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5e0d69bfe4854f1aa4176290eff945bf84dd7dd48646b6e4b57a3c82178747a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5e0d69bfe4854f1aa4176290eff945bf84dd7dd48646b6e4b57a3c82178747a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3ccdf6f892336fd129f405d10bfbf41e83b4ed41964cf371a9ab38c69b79e8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ad138dcd28017250be3c1601fcebd719fbe53a989cb46c6b266714451148dd9"
    sha256 cellar: :any,                 x86_64_linux:  "04bf58ca3344259644b9d6b7dc867327434c9393e109e7038eaf555b5b4d63f1"
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