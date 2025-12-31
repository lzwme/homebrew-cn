class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https://redocly.com/docs/cli"
  url "https://registry.npmjs.org/@redocly/cli/-/cli-2.14.2.tgz"
  sha256 "43355a0b4257081510a01e72ec3a3e25aae5692f7020db4e7097e1d11acb1fd6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e27bb00141e8b5ef9f6e23a6343121bf11c4909943e8afe7c06efde53629d905"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b977cf0be8dadb918c893233803fb9ca0b002bc9e480594fe67c0c2da14caf31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b977cf0be8dadb918c893233803fb9ca0b002bc9e480594fe67c0c2da14caf31"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcef0d8b91975ef99f79227b210fc1102e69d577131b25aa3747a1fd012b337e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9126d4c98c2686cb3463337a9a50d40a997d1d9fd9c323b18a106dede6094dd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9126d4c98c2686cb3463337a9a50d40a997d1d9fd9c323b18a106dede6094dd6"
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