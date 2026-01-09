class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https://redocly.com/docs/cli"
  url "https://registry.npmjs.org/@redocly/cli/-/cli-2.14.4.tgz"
  sha256 "3df1637f4a3e1499815917ece390252cdc0c002a46969b41fd4011991865e5a6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1588d4a0024fa4ac8752425f2e0f1d57d596f312f40695465dd0274b859ac51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d315ce00e72fa7c679be4a8105157ba83804e3b514dba9966d93477e425774c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d315ce00e72fa7c679be4a8105157ba83804e3b514dba9966d93477e425774c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef0fa832ee75375f583a56b72fe58e812515b0f62a08ee15b8289313fedac764"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12f02b1adf73dd6c70ede4d09e3463a183a96ed7b3e944f355f21c980aded7e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12f02b1adf73dd6c70ede4d09e3463a183a96ed7b3e944f355f21c980aded7e8"
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