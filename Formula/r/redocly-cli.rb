class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https://redocly.com/docs/cli"
  url "https://registry.npmjs.org/@redocly/cli/-/cli-2.0.3.tgz"
  sha256 "ce2fc0ca8726406acac3eeee01c6a24934dcd857f2e1b6f5770ba71556866f15"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eab2841f3d5eed9eb80ceecf83cc61d058f2cf67fb464efa682e7f1d74d9c15d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eab2841f3d5eed9eb80ceecf83cc61d058f2cf67fb464efa682e7f1d74d9c15d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eab2841f3d5eed9eb80ceecf83cc61d058f2cf67fb464efa682e7f1d74d9c15d"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcbfd85401b02fd244d8eb51808792a75d53a654807f69040deb34d89d0773e9"
    sha256 cellar: :any_skip_relocation, ventura:       "bcbfd85401b02fd244d8eb51808792a75d53a654807f69040deb34d89d0773e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eab2841f3d5eed9eb80ceecf83cc61d058f2cf67fb464efa682e7f1d74d9c15d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eab2841f3d5eed9eb80ceecf83cc61d058f2cf67fb464efa682e7f1d74d9c15d"
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