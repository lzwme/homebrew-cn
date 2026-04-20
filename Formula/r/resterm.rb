class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.29.2.tar.gz"
  sha256 "9959a411a9ab1259514e98e8f5459ac312018ef1b611a0d08493acf4dd40ff1d"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98ca59179d16f2fc61d135e92cb7129bff48497a387cbc077c7711b19f9409ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98ca59179d16f2fc61d135e92cb7129bff48497a387cbc077c7711b19f9409ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98ca59179d16f2fc61d135e92cb7129bff48497a387cbc077c7711b19f9409ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c87bd2e3d129183040754d2ffd52fc1c4b85fd0393b9c8ad26b8ca0adefc0d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7d92f6e28a845e3c40dab6332ab4d539bd32afbdfc0a2004a906a16e6eec568"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf55ac02e5f698df709df17a072378965d1377ac591758c29eba541f52492efd"
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