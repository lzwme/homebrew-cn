class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https://redocly.com/docs/cli"
  url "https://registry.npmjs.org/@redocly/cli/-/cli-2.14.7.tgz"
  sha256 "53f14e5f959663e7c4a8efab15bdfd5eda5ca0e243e60c745f1bfb8ecee42df9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ffe25706438925a1af988792641f9bbdc40bd9c0986c7049b2ce16bb7e56511"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93f146bab5f31209819688ceade0c44abff3e8a3ab5aeae96dcb60cf19b7b013"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93f146bab5f31209819688ceade0c44abff3e8a3ab5aeae96dcb60cf19b7b013"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7ae662eb42388a9e5acf298dc923b5a533f6910107cf6ea499cd7e30685d29d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef4954a98b6bc046641c5e8c05c092456e83c9ca99d7d3372d6b5de8dc718b7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef4954a98b6bc046641c5e8c05c092456e83c9ca99d7d3372d6b5de8dc718b7e"
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