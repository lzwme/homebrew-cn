class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https://redocly.com/docs/cli"
  url "https://registry.npmjs.org/@redocly/cli/-/cli-2.12.3.tgz"
  sha256 "cb8ff3ee65b02d53a47cb785681378ad179691fad8c51386d768b10f9e2805da"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "505812b03a23d9690067b43b2122521df9312f9c4b8b8e5b73ef1b0ca41c5663"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69645367ab7e7006b75213131d7ccebeb321bf013dd7ab3557d974816141d448"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69645367ab7e7006b75213131d7ccebeb321bf013dd7ab3557d974816141d448"
    sha256 cellar: :any_skip_relocation, sonoma:        "f035542f3859cd669f08a0dcc24d532729d83f638e375c763537e635fd1c36f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "307d81ab7a24483902eabdce64a25ca97a096e5bdaa433421706cdcee6a987b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "307d81ab7a24483902eabdce64a25ca97a096e5bdaa433421706cdcee6a987b3"
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