class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https://redocly.com/docs/cli"
  url "https://registry.npmjs.org/@redocly/cli/-/cli-2.13.0.tgz"
  sha256 "cbc47d6222a6cd49155ba1934141d8a187746873a6b7c1bdf246f039d5085a0b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5eadc5506c27dad2c0860ed2227f0c5c6615325bcc07acc9048809f14363b55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a66b5f6d899e66034ac35b6699b8002017912a6e6b32dda06d028d7fbd3649e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a66b5f6d899e66034ac35b6699b8002017912a6e6b32dda06d028d7fbd3649e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "710e2a10b96288980c3cdb03a3faa892269c0cb2c6d72c3c183548d3cd88d6e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d716cc743b576aebe0a55427e5c8464554449cf231651839ac1326368af6f44a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d716cc743b576aebe0a55427e5c8464554449cf231651839ac1326368af6f44a"
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