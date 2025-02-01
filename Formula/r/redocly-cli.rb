class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https:redocly.comdocscli"
  url "https:registry.npmjs.org@redoclycli-cli-1.28.0.tgz"
  sha256 "66e2cfc550feaa40017c927fb0e83c51fcbde6a8f6d7bbd3befe0806c952c80c"
  license "MIT"
  head "https:github.comredoclyredocly-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bc51384214e3eaa2c1fa01647a3db439a79cb96e43d3f41e84b1d04f45690e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bc51384214e3eaa2c1fa01647a3db439a79cb96e43d3f41e84b1d04f45690e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9bc51384214e3eaa2c1fa01647a3db439a79cb96e43d3f41e84b1d04f45690e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d903b13018f35dded2762a4e4d0d935e35b3f9662f46f854ba0e2ec185c3cc1f"
    sha256 cellar: :any_skip_relocation, ventura:       "d903b13018f35dded2762a4e4d0d935e35b3f9662f46f854ba0e2ec185c3cc1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bc51384214e3eaa2c1fa01647a3db439a79cb96e43d3f41e84b1d04f45690e5"
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