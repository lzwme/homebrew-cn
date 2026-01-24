class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https://redocly.com/docs/cli"
  url "https://registry.npmjs.org/@redocly/cli/-/cli-2.14.9.tgz"
  sha256 "e170f5079346a080dd8931f0b8e99c2c2d2cd1f7575876e9b08f7b33957beaf3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5cd64b431a01ca6f17c5d4c40e69cad511b973629f77a4ee87ddfa1b7065d71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa5d8a7f5792c8c65022156dc71ee56918954a3bb773cae11af13e8e030ff4a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa5d8a7f5792c8c65022156dc71ee56918954a3bb773cae11af13e8e030ff4a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d27272a331df8d02b642961df2241801ff627148a43a9f3f66ea96ba277f516"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "674ae6c39b6952a520c77c4f274461c240bcbf23d43f2272acdcebdc13ab9fa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "674ae6c39b6952a520c77c4f274461c240bcbf23d43f2272acdcebdc13ab9fa5"
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