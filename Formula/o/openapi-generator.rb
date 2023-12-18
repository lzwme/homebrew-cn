class OpenapiGenerator < Formula
  desc "Generate clients, server & docs from an OpenAPI spec (v2, v3)"
  homepage "https:openapi-generator.tech"
  url "https:search.maven.orgremotecontent?filepath=orgopenapitoolsopenapi-generator-cli7.1.0openapi-generator-cli-7.1.0.jar"
  sha256 "85fab7a4d80a9e1e65c5824bcd375c39ad294af07490609529c8e78a7bda673a"
  license "Apache-2.0"

  livecheck do
    url "https:search.maven.orgremotecontent?filepath=orgopenapitoolsopenapi-generator-climaven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)<version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ee3a68227c47e35513428021bed8ebc4869387909310db99e247932bf20aa4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ee3a68227c47e35513428021bed8ebc4869387909310db99e247932bf20aa4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ee3a68227c47e35513428021bed8ebc4869387909310db99e247932bf20aa4a"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ee3a68227c47e35513428021bed8ebc4869387909310db99e247932bf20aa4a"
    sha256 cellar: :any_skip_relocation, ventura:        "0ee3a68227c47e35513428021bed8ebc4869387909310db99e247932bf20aa4a"
    sha256 cellar: :any_skip_relocation, monterey:       "0ee3a68227c47e35513428021bed8ebc4869387909310db99e247932bf20aa4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b553a12e8b41e87d041cec6adb90dfcd0619c7af145fcf4486070a37cc4e00e8"
  end

  head do
    url "https:github.comOpenAPIToolsopenapi-generator.git", branch: "master"

    depends_on "maven" => :build
  end

  depends_on "openjdk@11"

  def install
    if build.head?
      system "mvn", "clean", "package", "-Dmaven.javadoc.skip=true"
      libexec.install "modulesopenapi-generator-clitargetopenapi-generator-cli.jar"
    else
      libexec.install "openapi-generator-cli-#{version}.jar" => "openapi-generator-cli.jar"
    end

    bin.write_jar_script libexec"openapi-generator-cli.jar", "openapi-generator", java_version: "11"
  end

  test do
    # From the OpenAPI Spec website
    # https:web.archive.orgweb20230505222426https:swagger.iodocsspecificationbasic-structure
    (testpath"minimal.yaml").write <<~EOS
      ---
      openapi: 3.0.3
      info:
        version: 0.0.0
        title: Sample API
      servers:
        - url: http:api.example.comv1
          description: Optional server description, e.g. Main (production) server
        - url: http:staging-api.example.com
          description: Optional server description, e.g. Internal staging server for testing
      paths:
        users:
          get:
            summary: Returns a list of users.
            responses:
              '200':
                description: A JSON array of user names
                content:
                  applicationjson:
                    schema:
                      type: array
                      items:
                        type: string
    EOS
    system bin"openapi-generator", "generate", "-i", "minimal.yaml", "-g", "openapi", "-o", "."
    # Python is broken for (at least) Java 20
    system bin"openapi-generator", "generate", "-i", "minimal.yaml", "-g", "python", "-o", "."
  end
end