class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "1b0241ea823d69d99d51c06c8c5229db0dc635775a6a6df3dee779ec3da476fd"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2cc4f80d6d8c65edc17b68e67ec790c406af4d30aac3ae35cb733b3d0e47b62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2cc4f80d6d8c65edc17b68e67ec790c406af4d30aac3ae35cb733b3d0e47b62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2cc4f80d6d8c65edc17b68e67ec790c406af4d30aac3ae35cb733b3d0e47b62"
    sha256 cellar: :any_skip_relocation, sonoma:        "77d6991b9f4b950fef3bdc94a8c09b9fc65dd520e08d8b54c7af86b64e18dc8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "991ab6b38aa35857407ee72dfec719896db8f745379bf618d31782a6868b3293"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99f0ca4f6b87857b6e904baf619c885772039b500c0b5edac9c767a93aef53bf"
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