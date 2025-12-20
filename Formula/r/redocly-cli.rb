class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https://redocly.com/docs/cli"
  url "https://registry.npmjs.org/@redocly/cli/-/cli-2.14.0.tgz"
  sha256 "5025117daf4977ca33b4fbeec4df38ba0cfac1430fab98f2287743b0d46ab436"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ace88f0dfc834cea5a3badff15cfb3dd4f62e62bb0b250351f48947ff9fac10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3a3a7a28417b7cdaeae81b2aa049c7c99e960818f873db2444940433b263149"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3a3a7a28417b7cdaeae81b2aa049c7c99e960818f873db2444940433b263149"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4d16d40baa0b97d128d793e8f9db514aeb18e4f0a470f86f832697283a8ac0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ebe71b4cac24351876af6d2cf71d6c874f2cadbb239d17fc2de32026e2b17bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ebe71b4cac24351876af6d2cf71d6c874f2cadbb239d17fc2de32026e2b17bd"
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