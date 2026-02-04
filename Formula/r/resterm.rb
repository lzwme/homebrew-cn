class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.21.2.tar.gz"
  sha256 "8f6ead24f9681da97760e718326f001a23f7221248e376e1ab5304433ef86fe5"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1000169d572108b821d856717f5cc3ca5cff30a53c3dcd867a2f7d57a6ffd225"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1000169d572108b821d856717f5cc3ca5cff30a53c3dcd867a2f7d57a6ffd225"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1000169d572108b821d856717f5cc3ca5cff30a53c3dcd867a2f7d57a6ffd225"
    sha256 cellar: :any_skip_relocation, sonoma:        "0bef72556b9bdaff4e6bf794a9bfb22f380339ca2481b069aa7108a962ef3ddc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b28ea32640604da42e6b813973ee0d3fc472441a5f891cc6adeafb295ab1603f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "946a7afe0a729458906a7e843fe564be887c67f7acd5b564e14aa1f3cd5ff7c3"
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