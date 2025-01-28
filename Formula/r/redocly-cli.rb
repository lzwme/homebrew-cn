class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https:redocly.comdocscli"
  url "https:registry.npmjs.org@redoclycli-cli-1.27.2.tgz"
  sha256 "9e80fc609cdc1628a532d23028f1565afd1a02fe8996848e6167b8046bf1c86d"
  license "MIT"
  head "https:github.comredoclyredocly-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "265df1dcf49808794e3489b951154d680777fbd3269e828f699729010bd20328"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "265df1dcf49808794e3489b951154d680777fbd3269e828f699729010bd20328"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "265df1dcf49808794e3489b951154d680777fbd3269e828f699729010bd20328"
    sha256 cellar: :any_skip_relocation, sonoma:        "21659e09a43a2551cd78a1aa80b5587bcb6f2e7441bbab6feaebfcd2f49e624f"
    sha256 cellar: :any_skip_relocation, ventura:       "21659e09a43a2551cd78a1aa80b5587bcb6f2e7441bbab6feaebfcd2f49e624f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "265df1dcf49808794e3489b951154d680777fbd3269e828f699729010bd20328"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec"binredocly"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}redocly --version")

    test_file = testpath"openapi.yaml"
    test_file.write <<~YML
      openapi: '3.0.0'
      info:
        version: 1.0.0
        title: Swagger Petstore
        description: test
        license:
          name: MIT
          url: https:opensource.orglicensesMIT
      servers: #ServerList
        - url: http:petstore.swagger.io:{Port}v1
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
        pets:
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
                  applicationjson:
                    encoding:
                      historyMetadata:
                        contentType: applicationjson; charset=utf-8
                links:
                  address:
                    operationId: getUserAddress
                    parameters:
                      userId: $request.path.id
    YML

    assert_match "Woohoo! Your API description is valid. 🎉",
      shell_output("#{bin}redocly lint --extends=minimal #{test_file} 2>&1")
  end
end