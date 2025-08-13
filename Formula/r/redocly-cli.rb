class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https://redocly.com/docs/cli"
  url "https://registry.npmjs.org/@redocly/cli/-/cli-2.0.4.tgz"
  sha256 "0ae9cae48fe163a8d9e43b6372b95dbd9be6d6d5b16ff31b1027476e80a4b2df"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a1eb3ee1b7d05cab24796eeb9dcf4d614fcae381f8b0a97a82962854888ef04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a1eb3ee1b7d05cab24796eeb9dcf4d614fcae381f8b0a97a82962854888ef04"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a1eb3ee1b7d05cab24796eeb9dcf4d614fcae381f8b0a97a82962854888ef04"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1b13349a6ffc356f389f879a3f5dabbb72df330e4e32a11cda802a4b1440a7a"
    sha256 cellar: :any_skip_relocation, ventura:       "b1b13349a6ffc356f389f879a3f5dabbb72df330e4e32a11cda802a4b1440a7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a1eb3ee1b7d05cab24796eeb9dcf4d614fcae381f8b0a97a82962854888ef04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a1eb3ee1b7d05cab24796eeb9dcf4d614fcae381f8b0a97a82962854888ef04"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/redocly --version")

    test_file = testpath/"openapi.yaml"
    test_file.write <<~YML
      openapi: '3.0.0'
      info:
        version: 1.0.0
        title: Swagger Petstore
        description: test
        license:
          name: MIT
          url: https://opensource.org/licenses/MIT
      servers: #ServerList
        - url: http://petstore.swagger.io:{Port}/v1
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
        /pets:
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
                  application/json:
                    encoding:
                      historyMetadata:
                        contentType: application/json; charset=utf-8
                links:
                  address:
                    operationId: getUserAddress
                    parameters:
                      userId: $request.path.id
    YML

    assert_match "Woohoo! Your API description is valid. 🎉",
      shell_output("#{bin}/redocly lint --extends=minimal #{test_file} 2>&1")
  end
end