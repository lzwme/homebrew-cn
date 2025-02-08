class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https:redocly.comdocscli"
  url "https:registry.npmjs.org@redoclycli-cli-1.28.5.tgz"
  sha256 "a7e2f3f62bc9bb6b5660ab875a411dda12667dbf5ac7cb65f6674a2205af8679"
  license "MIT"
  head "https:github.comredoclyredocly-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74f3cea7aac8ef187c9cade6e3c1d49122d5b7bea09d986d5caf463e0f2546df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74f3cea7aac8ef187c9cade6e3c1d49122d5b7bea09d986d5caf463e0f2546df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "74f3cea7aac8ef187c9cade6e3c1d49122d5b7bea09d986d5caf463e0f2546df"
    sha256 cellar: :any_skip_relocation, sonoma:        "a47ba8778d4aed49a563ff95028284c26c926d2c090e6e0c908dd52b7d42a463"
    sha256 cellar: :any_skip_relocation, ventura:       "a47ba8778d4aed49a563ff95028284c26c926d2c090e6e0c908dd52b7d42a463"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74f3cea7aac8ef187c9cade6e3c1d49122d5b7bea09d986d5caf463e0f2546df"
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