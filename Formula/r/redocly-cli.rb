class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https:redocly.comdocscli"
  url "https:registry.npmjs.org@redoclycli-cli-1.33.1.tgz"
  sha256 "2221565c8b23321c53088543e48b0d71a082e62a5ef4190eafb9a230e0de161f"
  license "MIT"
  head "https:github.comredoclyredocly-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a25c2a01ccf9f05d275323dc2c465d693aa9bd74f58bce455d4423428d120565"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a25c2a01ccf9f05d275323dc2c465d693aa9bd74f58bce455d4423428d120565"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a25c2a01ccf9f05d275323dc2c465d693aa9bd74f58bce455d4423428d120565"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd7f361fee2f87a42c6bbfaea82c3c3da323f79435c5e8066f5151fed513f4d8"
    sha256 cellar: :any_skip_relocation, ventura:       "cd7f361fee2f87a42c6bbfaea82c3c3da323f79435c5e8066f5151fed513f4d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ffff4b02e34d77bebf96371df139b4578e3002f3c3ff3b19987c042f7d21870"
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