class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https://redocly.com/docs/cli"
  url "https://registry.npmjs.org/@redocly/cli/-/cli-2.12.7.tgz"
  sha256 "62436d0c305cda81d84e50c921949f2436444fc03ce35cc90911d07e6d78b924"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f68f9f9e605e048fa03ad3dcacef3453bc8d2eb2d19f515f228adf22e348f474"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6c8ef8b4102cc628814f34caef4c2a7444bc4f7b33de523b48a4036ccbb74e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6c8ef8b4102cc628814f34caef4c2a7444bc4f7b33de523b48a4036ccbb74e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc8a5b6ca77842d1d0184525fc84eaa81b544696eacf6b6ecea6b547a06bbc6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23e3385ae4550fe961a894aac707fd664de7e3884593fd660b80d984d8f6bee7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23e3385ae4550fe961a894aac707fd664de7e3884593fd660b80d984d8f6bee7"
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