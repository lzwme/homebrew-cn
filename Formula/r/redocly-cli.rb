class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https:redocly.comdocscli"
  url "https:registry.npmjs.org@redoclycli-cli-1.29.0.tgz"
  sha256 "7f94ef3cd5b8529535ace5c21b6fdb20b542caf09cd4ab3e41555d000bfa189b"
  license "MIT"
  head "https:github.comredoclyredocly-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c628c034900b591dddf0bd84329c0c1e032090f1d68fc332f7231d87cdfdac43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c628c034900b591dddf0bd84329c0c1e032090f1d68fc332f7231d87cdfdac43"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c628c034900b591dddf0bd84329c0c1e032090f1d68fc332f7231d87cdfdac43"
    sha256 cellar: :any_skip_relocation, sonoma:        "a44777ef04cb8101c3e3d8f2ab99c11966271c348378de634c37481e9b919ffd"
    sha256 cellar: :any_skip_relocation, ventura:       "a44777ef04cb8101c3e3d8f2ab99c11966271c348378de634c37481e9b919ffd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c628c034900b591dddf0bd84329c0c1e032090f1d68fc332f7231d87cdfdac43"
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