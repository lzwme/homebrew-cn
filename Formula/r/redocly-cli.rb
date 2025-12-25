class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https://redocly.com/docs/cli"
  url "https://registry.npmjs.org/@redocly/cli/-/cli-2.14.1.tgz"
  sha256 "262b37115a7581c096c695673948910fb4a2aadbf8ab2b613ad9cb5788054ef3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc7230790133c849bb9a8bc8d5209307f8437d3f78a710b64e65c6c8b58d9c6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a317c11a1e766cbf7e41871b560d36afa2c0bb03bc5e0dcfe7ca906f649b9d04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a317c11a1e766cbf7e41871b560d36afa2c0bb03bc5e0dcfe7ca906f649b9d04"
    sha256 cellar: :any_skip_relocation, sonoma:        "32795afdd569e01ce4a9349a1054faf9352e362d4c6a5de4984496ed8bd09552"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8230f17445adc079ee1c64505e3c80d52b9fe91de858546c9451baa306d706e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8230f17445adc079ee1c64505e3c80d52b9fe91de858546c9451baa306d706e3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@redocly/cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
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