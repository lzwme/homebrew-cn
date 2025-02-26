class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https:redocly.comdocscli"
  url "https:registry.npmjs.org@redoclycli-cli-1.31.1.tgz"
  sha256 "4d843056ca9ee6f141d0c36bff6adccc6b5e417d3f6bc868282b582f4085bfd6"
  license "MIT"
  head "https:github.comredoclyredocly-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec52a0fa5861ecc10431e3bc55af4439d09c6352b861cedf46713cb8b4c52631"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec52a0fa5861ecc10431e3bc55af4439d09c6352b861cedf46713cb8b4c52631"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec52a0fa5861ecc10431e3bc55af4439d09c6352b861cedf46713cb8b4c52631"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfbf0027826321a950a6e6dc4a9662ddd0181e80f2ae87dcaf081dc3f770b537"
    sha256 cellar: :any_skip_relocation, ventura:       "dfbf0027826321a950a6e6dc4a9662ddd0181e80f2ae87dcaf081dc3f770b537"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec52a0fa5861ecc10431e3bc55af4439d09c6352b861cedf46713cb8b4c52631"
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