class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https://redocly.com/docs/cli"
  url "https://registry.npmjs.org/@redocly/cli/-/cli-2.12.6.tgz"
  sha256 "cb05b2b52bedd20cbd4260532c73373dcb9c68bfaba27f41f2157da48dceede7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d4cb3be7dc58d2c58a0274d5a2aaba6b87a2140a92874784be859f6da93761b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5bb476cb8190f85407f3a11d66f44b1a4c8af141477049517cf876a6c68a602"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5bb476cb8190f85407f3a11d66f44b1a4c8af141477049517cf876a6c68a602"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ffc7aefe852fdcf2de5b220a405d361fe1da777d5491f8a971a136945a0e961"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fde745c39940342a503baca2cb8d6011b15953224dab6792f3ab8444b5d45874"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fde745c39940342a503baca2cb8d6011b15953224dab6792f3ab8444b5d45874"
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