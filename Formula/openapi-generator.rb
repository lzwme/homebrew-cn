class OpenapiGenerator < Formula
  desc "Generate clients, server & docs from an OpenAPI spec (v2, v3)"
  homepage "https://openapi-generator.tech/"
  url "https://search.maven.org/remotecontent?filepath=org/openapitools/openapi-generator-cli/6.6.0/openapi-generator-cli-6.6.0.jar"
  sha256 "9718ff7844e89462c75dcd9b20a35136f6db257bfe1b874db1e3002e99de4609"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/openapitools/openapi-generator-cli/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "171e95f84c7fd159326a2c152e4d6683265e4c0925d7ed696c2a2ceb0485d18c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "171e95f84c7fd159326a2c152e4d6683265e4c0925d7ed696c2a2ceb0485d18c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "171e95f84c7fd159326a2c152e4d6683265e4c0925d7ed696c2a2ceb0485d18c"
    sha256 cellar: :any_skip_relocation, ventura:        "171e95f84c7fd159326a2c152e4d6683265e4c0925d7ed696c2a2ceb0485d18c"
    sha256 cellar: :any_skip_relocation, monterey:       "171e95f84c7fd159326a2c152e4d6683265e4c0925d7ed696c2a2ceb0485d18c"
    sha256 cellar: :any_skip_relocation, big_sur:        "171e95f84c7fd159326a2c152e4d6683265e4c0925d7ed696c2a2ceb0485d18c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5cf22e1c4d71e523e2cbc43ce6fd724cbb1a431c122de1e5204ef3b78501999"
  end

  head do
    url "https://github.com/OpenAPITools/openapi-generator.git", branch: "master"

    depends_on "maven" => :build
  end

  depends_on "openjdk@11"

  def install
    if build.head?
      system "mvn", "clean", "package", "-Dmaven.javadoc.skip=true"
      libexec.install "modules/openapi-generator-cli/target/openapi-generator-cli.jar"
    else
      libexec.install "openapi-generator-cli-#{version}.jar" => "openapi-generator-cli.jar"
    end

    bin.write_jar_script libexec/"openapi-generator-cli.jar", "openapi-generator", java_version: "11"
  end

  test do
    # From the OpenAPI Spec website
    # https://web.archive.org/web/20230505222426/https://swagger.io/docs/specification/basic-structure/
    (testpath/"minimal.yaml").write <<~EOS
      ---
      openapi: 3.0.3
      info:
        version: 0.0.0
        title: Sample API
      servers:
        - url: http://api.example.com/v1
          description: Optional server description, e.g. Main (production) server
        - url: http://staging-api.example.com
          description: Optional server description, e.g. Internal staging server for testing
      paths:
        /users:
          get:
            summary: Returns a list of users.
            responses:
              '200':
                description: A JSON array of user names
                content:
                  application/json:
                    schema:
                      type: array
                      items:
                        type: string
    EOS
    system bin/"openapi-generator", "generate", "-i", "minimal.yaml", "-g", "openapi", "-o", "./"
    # Python is broken for (at least) Java 20
    system bin/"openapi-generator", "generate", "-i", "minimal.yaml", "-g", "python", "-o", "./"
  end
end