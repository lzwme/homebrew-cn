class OpenapiGenerator < Formula
  desc "Generate clients, server & docs from an OpenAPI spec (v2, v3)"
  homepage "https:openapi-generator.tech"
  url "https:search.maven.orgremotecontent?filepath=orgopenapitoolsopenapi-generator-cli7.11.0openapi-generator-cli-7.11.0.jar"
  sha256 "113c25df5a781d5a1fc2b883f12fe8f263db285ab12e15854d5b15306e1bf7fc"
  license "Apache-2.0"

  livecheck do
    url "https:search.maven.orgremotecontent?filepath=orgopenapitoolsopenapi-generator-climaven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)<version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ec269873d2848f8720e22647684662d000d3d0978825b2b7c5682fa30652b890"
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
    (testpath"minimal.yaml").write <<~YAML
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
    YAML
    system bin"openapi-generator", "generate", "-i", "minimal.yaml", "-g", "openapi", "-o", "."
    # Python is broken for (at least) Java 20
    system bin"openapi-generator", "generate", "-i", "minimal.yaml", "-g", "python", "-o", "."
  end
end