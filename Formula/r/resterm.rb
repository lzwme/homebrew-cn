class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://ghfast.top/https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "d3d44d45728fe4c1a0fb5f36621b555abef0cdeba179973f5f03ac4700adb924"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2412ec3d68eb7956671a63d144d4ecdf3ab407d4a7395b4de1dd4defd9062c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2412ec3d68eb7956671a63d144d4ecdf3ab407d4a7395b4de1dd4defd9062c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2412ec3d68eb7956671a63d144d4ecdf3ab407d4a7395b4de1dd4defd9062c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "40ba8ae63f69978e92bc609f6457415b4028e9d6ad7a02a420af1a7f32f6d784"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f9e139e27edb79df56149da34172b63d353a2fc96a14234abe04b2981173cfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f90585c133f2b20c329c179d0400adacb156855c1fc57e452d843bf91e1ce277"
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