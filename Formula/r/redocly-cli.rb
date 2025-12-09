class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https://redocly.com/docs/cli"
  url "https://registry.npmjs.org/@redocly/cli/-/cli-2.12.4.tgz"
  sha256 "1806b6710155769231391ddece85f5822350aa344bf9412ac46bb4d1205d503a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "349444d9279b58568b10e9229bcfe5ef29285d0972948ea40accd6ed347f7555"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "715c6c9de02c993b40847ca3bf71dc5be2f2da29ce9239bc806aa79bbfaaf879"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "715c6c9de02c993b40847ca3bf71dc5be2f2da29ce9239bc806aa79bbfaaf879"
    sha256 cellar: :any_skip_relocation, sonoma:        "389fc06cb1802ad1e9475cb97742aa5464a6b16c022764562314702a7a5208b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38717757142b3361f5e3e7917c82113b5b5a1f098b8e2a13aec421a1253c64a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38717757142b3361f5e3e7917c82113b5b5a1f098b8e2a13aec421a1253c64a7"
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