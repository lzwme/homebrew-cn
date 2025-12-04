class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https://redocly.com/docs/cli"
  url "https://registry.npmjs.org/@redocly/cli/-/cli-2.12.2.tgz"
  sha256 "690c6c2e3622d45f172354b27e477b814c54f19fc7d281ae7b8ceb495e40bc75"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9862c04352119728cd766ac9f96842dcec77cb25449e75d7a359a56b086d5d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bc852fe5d406f4f996b29cd0c55f0d2d884d880365cc32f1dbab7c260f123ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bc852fe5d406f4f996b29cd0c55f0d2d884d880365cc32f1dbab7c260f123ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fc89971356ee0c9a49a23d0ae47fb4b44430cce149b59c73df06465a382615a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fa33408db51d7b6021a35ab35bc3d7898d283381a7f21ea0dd1b9383f4ce328"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fa33408db51d7b6021a35ab35bc3d7898d283381a7f21ea0dd1b9383f4ce328"
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