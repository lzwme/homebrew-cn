class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https:redocly.comdocscli"
  url "https:registry.npmjs.org@redoclycli-cli-1.28.3.tgz"
  sha256 "e314633441c48c8eb92e124634457e0fa92187f455e7c0d90297f961842293f0"
  license "MIT"
  head "https:github.comredoclyredocly-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "884ef9f66ad99d5ee7a4c32c7cc53a56fbdabb9da1b05c4d1aed68a17be67081"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "884ef9f66ad99d5ee7a4c32c7cc53a56fbdabb9da1b05c4d1aed68a17be67081"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "884ef9f66ad99d5ee7a4c32c7cc53a56fbdabb9da1b05c4d1aed68a17be67081"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5ad6ad395d8d30b9e92a1d3135f975c0d1b2005587571762868187cdc0062ee"
    sha256 cellar: :any_skip_relocation, ventura:       "a5ad6ad395d8d30b9e92a1d3135f975c0d1b2005587571762868187cdc0062ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "884ef9f66ad99d5ee7a4c32c7cc53a56fbdabb9da1b05c4d1aed68a17be67081"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec"binredocly"
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