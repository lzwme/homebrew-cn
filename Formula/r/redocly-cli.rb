class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https://redocly.com/docs/cli"
  url "https://registry.npmjs.org/@redocly/cli/-/cli-2.14.3.tgz"
  sha256 "3b30545e2cb1e2703f75890a50e38e2c4453dd648e60a2e63052eb7b1990d792"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c92ef1aaf5eed51437ca05df260c925fb085f7c053ed1416c355565d8288f0ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0ce536b8801de3bde7bf2f38896cc72c623b2f9d03b1eaf63ced84732d77433"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0ce536b8801de3bde7bf2f38896cc72c623b2f9d03b1eaf63ced84732d77433"
    sha256 cellar: :any_skip_relocation, sonoma:        "027bc61feacf7e103f37f1129e17964543d01a1060076cc8e670e5ac8a0221de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b1a35968770ee88902d3e3f72b57f241eabbc9e147950a5e1dedf18713cfbb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b1a35968770ee88902d3e3f72b57f241eabbc9e147950a5e1dedf18713cfbb7"
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