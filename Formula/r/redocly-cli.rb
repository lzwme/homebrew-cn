class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https:redocly.comdocscli"
  url "https:registry.npmjs.org@redoclycli-cli-1.34.0.tgz"
  sha256 "1f22abb6c3bdc061af6283f37c765be01162bc15ca261831f493b156353b129a"
  license "MIT"
  head "https:github.comredoclyredocly-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3cc99dc249a47986396eb5c648e4e6d4fc6a6671ed9e9f7d1b98185bb6fbae6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3cc99dc249a47986396eb5c648e4e6d4fc6a6671ed9e9f7d1b98185bb6fbae6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3cc99dc249a47986396eb5c648e4e6d4fc6a6671ed9e9f7d1b98185bb6fbae6"
    sha256 cellar: :any_skip_relocation, sonoma:        "daedfeec2f7d3a2caf47ef6f73133d789c416003d0ef3c64bd46668325203ccd"
    sha256 cellar: :any_skip_relocation, ventura:       "daedfeec2f7d3a2caf47ef6f73133d789c416003d0ef3c64bd46668325203ccd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c84dacf975208a011aa343d542e0aaa6f3bbc00643f6e86b570c0b4f9c494799"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3cc99dc249a47986396eb5c648e4e6d4fc6a6671ed9e9f7d1b98185bb6fbae6"
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