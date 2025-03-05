class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https:redocly.comdocscli"
  url "https:registry.npmjs.org@redoclycli-cli-1.32.2.tgz"
  sha256 "1e1ddde585eb6ab52fc700d781211e6320722960d895afcae8b898de4b50c022"
  license "MIT"
  head "https:github.comredoclyredocly-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a966f5582dd4c2c4c48696bbd9ea7c116bbfdc6ee45af69b9f0ac67822621886"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a966f5582dd4c2c4c48696bbd9ea7c116bbfdc6ee45af69b9f0ac67822621886"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a966f5582dd4c2c4c48696bbd9ea7c116bbfdc6ee45af69b9f0ac67822621886"
    sha256 cellar: :any_skip_relocation, sonoma:        "67a10dc546248d019620f14fdb9910a5ab248c123f777cf9c8b197c4b082ee14"
    sha256 cellar: :any_skip_relocation, ventura:       "67a10dc546248d019620f14fdb9910a5ab248c123f777cf9c8b197c4b082ee14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a966f5582dd4c2c4c48696bbd9ea7c116bbfdc6ee45af69b9f0ac67822621886"
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