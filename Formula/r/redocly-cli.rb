class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https://redocly.com/docs/cli"
  url "https://registry.npmjs.org/@redocly/cli/-/cli-1.34.5.tgz"
  sha256 "c035ea5aaac72926ca78a7d63d652263953e1d7efcd698894c81a1f9378fb2df"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba9070f1336319140bacaf2d821d99021c270eaea6bdb2a9b911f00f36c65f0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba9070f1336319140bacaf2d821d99021c270eaea6bdb2a9b911f00f36c65f0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba9070f1336319140bacaf2d821d99021c270eaea6bdb2a9b911f00f36c65f0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f23b3b2ad4196207ce2e891094709c712b2532a94819b6a16fa60b2205aa00b"
    sha256 cellar: :any_skip_relocation, ventura:       "3f23b3b2ad4196207ce2e891094709c712b2532a94819b6a16fa60b2205aa00b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba9070f1336319140bacaf2d821d99021c270eaea6bdb2a9b911f00f36c65f0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba9070f1336319140bacaf2d821d99021c270eaea6bdb2a9b911f00f36c65f0a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/redocly --version")

    test_file = testpath/"openapi.yaml"
    test_file.write <<~YML
      openapi: '3.0.0'
      info:
        version: 1.0.0
        title: Swagger Petstore
        description: test
        license:
          name: MIT
          url: https://opensource.org/licenses/MIT
      servers: #ServerList
        - url: http://petstore.swagger.io:{Port}/v1
          variables:
            Port:
              enum:
                - '8443'
                - '443'
              default: '8443'
      security: [] # SecurityRequirementList
      tags: # TagList
        - name: pets
          description: Test description
        - name: store
          description: Access to Petstore orders
      paths:
        /pets:
          get:
            summary: List all pets
            operationId: list_pets
            tags:
              - pets
            parameters:
              - name: Accept-Language
                in: header
                description: 'The language you prefer for messages. Supported values are en-AU, en-CA, en-GB, en-US'
                example: en-US
                required: false
                schema:
                  type: string
                  default: en-AU
            responses:
              '200':
                description: An paged array of pets
                headers:
                  x-next:
                    description: A link to the next page of responses
                    schema:
                      type: string
                content:
                  application/json:
                    encoding:
                      historyMetadata:
                        contentType: application/json; charset=utf-8
                links:
                  address:
                    operationId: getUserAddress
                    parameters:
                      userId: $request.path.id
    YML

    assert_match "Woohoo! Your API description is valid. 🎉",
      shell_output("#{bin}/redocly lint --extends=minimal #{test_file} 2>&1")
  end
end