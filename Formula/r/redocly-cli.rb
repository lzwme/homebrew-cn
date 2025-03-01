class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https:redocly.comdocscli"
  url "https:registry.npmjs.org@redoclycli-cli-1.31.3.tgz"
  sha256 "337e947738e0980c8ec697a4aaf0e07eff4989a2a79b256a614a76ad6e2ef9b5"
  license "MIT"
  head "https:github.comredoclyredocly-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b2b28aa228901d73589a2e8bd5aea866b81b3f523e8de7bf623e8d260671495"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b2b28aa228901d73589a2e8bd5aea866b81b3f523e8de7bf623e8d260671495"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b2b28aa228901d73589a2e8bd5aea866b81b3f523e8de7bf623e8d260671495"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ece36f42427c42229572130607e348b2ebb4c118cb43191ef654728ed98d2ea"
    sha256 cellar: :any_skip_relocation, ventura:       "4ece36f42427c42229572130607e348b2ebb4c118cb43191ef654728ed98d2ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b2b28aa228901d73589a2e8bd5aea866b81b3f523e8de7bf623e8d260671495"
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