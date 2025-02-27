class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https:redocly.comdocscli"
  url "https:registry.npmjs.org@redoclycli-cli-1.31.2.tgz"
  sha256 "b3f5d0421007e9d68b529bf1550924234b7510d189b29cc20895e613b65d7005"
  license "MIT"
  head "https:github.comredoclyredocly-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7f36a0486cb6a9fb53b51760c4ae4d8eba0def1046c8bbba6a52b2c4809c32e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7f36a0486cb6a9fb53b51760c4ae4d8eba0def1046c8bbba6a52b2c4809c32e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7f36a0486cb6a9fb53b51760c4ae4d8eba0def1046c8bbba6a52b2c4809c32e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a02f054ebee0529a26825d45b9c8fc032daadfca432142d7ab28506b73a5a113"
    sha256 cellar: :any_skip_relocation, ventura:       "a02f054ebee0529a26825d45b9c8fc032daadfca432142d7ab28506b73a5a113"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7f36a0486cb6a9fb53b51760c4ae4d8eba0def1046c8bbba6a52b2c4809c32e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}redocly --version")

    test_file = testpath"openapi.yaml"
    test_file.write <<~YML
      openapi: '3.0.0'
      info:
        version: 1.0.0
        title: Swagger Petstore
        description: test
        license:
          name: MIT
          url: https:opensource.orglicensesMIT
      servers: #ServerList
        - url: http:petstore.swagger.io:{Port}v1
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
        pets:
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
                  applicationjson:
                    encoding:
                      historyMetadata:
                        contentType: applicationjson; charset=utf-8
                links:
                  address:
                    operationId: getUserAddress
                    parameters:
                      userId: $request.path.id
    YML

    assert_match "Woohoo! Your API description is valid. 🎉",
      shell_output("#{bin}redocly lint --extends=minimal #{test_file} 2>&1")
  end
end