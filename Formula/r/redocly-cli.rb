class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https://redocly.com/docs/cli"
  url "https://registry.npmjs.org/@redocly/cli/-/cli-2.12.5.tgz"
  sha256 "ecd5e76df51843cb708e68b960e70ab41c20600474415f378ac30915509426cf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3889a38c2fce6dcd77e6cf974af1b54c30fbed36af68ca58ed999fd201e1291"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d808bef7ea2d26266e3d48d559f4350d5543f9e22b81c14b162dbef8f81d57ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d808bef7ea2d26266e3d48d559f4350d5543f9e22b81c14b162dbef8f81d57ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a329e7eaa17ea77239e1fe7f6348eb79464eebbb61a4295b282cc183b6dcf62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2b82036e3f4bd5e52c0a6e9f533af36d82fa3a0c34b697a2f154cdea9f28997"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2b82036e3f4bd5e52c0a6e9f533af36d82fa3a0c34b697a2f154cdea9f28997"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@redocly/cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
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