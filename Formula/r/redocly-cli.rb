class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https://redocly.com/docs/cli"
  url "https://registry.npmjs.org/@redocly/cli/-/cli-2.0.2.tgz"
  sha256 "3b6cc6ee13ae9d458ad015c0438fae296444021bec40fba4ef577458e0211bab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0539a8da7b7da45b20ebf8d570eb3fcfde253dd87dd57b47643ffacdd9f0fd72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0539a8da7b7da45b20ebf8d570eb3fcfde253dd87dd57b47643ffacdd9f0fd72"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0539a8da7b7da45b20ebf8d570eb3fcfde253dd87dd57b47643ffacdd9f0fd72"
    sha256 cellar: :any_skip_relocation, sonoma:        "fffe0dd0b347726242fe1440caaf3cba31f865605b63493dab6fe266eaf80d1e"
    sha256 cellar: :any_skip_relocation, ventura:       "fffe0dd0b347726242fe1440caaf3cba31f865605b63493dab6fe266eaf80d1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0539a8da7b7da45b20ebf8d570eb3fcfde253dd87dd57b47643ffacdd9f0fd72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0539a8da7b7da45b20ebf8d570eb3fcfde253dd87dd57b47643ffacdd9f0fd72"
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