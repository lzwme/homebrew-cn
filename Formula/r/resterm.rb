class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.23.4.tar.gz"
  sha256 "d301088aa6c96142ba0cdca57193ffa6eb86a0b09e68c6fbdf9a85fe7b93c8ab"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66cb32cf34172d30f32ac11ccf646df242247c768014b3fa3f5c1aef4f26004c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66cb32cf34172d30f32ac11ccf646df242247c768014b3fa3f5c1aef4f26004c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66cb32cf34172d30f32ac11ccf646df242247c768014b3fa3f5c1aef4f26004c"
    sha256 cellar: :any_skip_relocation, sonoma:        "146b508f192036a22e4f26d8b182036a776029f622938b3ef542d980515698d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdd2ac2dc6a2de9bc2416d63598da6b065942908137b99ceff6bb38b863f711e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f0ada52950a941b6283900e054cf40e13001c2ca2eef967ed471c7e5a64897e"
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