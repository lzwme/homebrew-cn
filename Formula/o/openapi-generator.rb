class OpenapiGenerator < Formula
  desc "Generate clients, server & docs from an OpenAPI spec (v2, v3)"
  homepage "https:openapi-generator.tech"
  url "https:search.maven.orgremotecontent?filepath=orgopenapitoolsopenapi-generator-cli7.4.0openapi-generator-cli-7.4.0.jar"
  sha256 "e42769a98fef5634bee0f921e4b90786a6b3292aa11fe8d2f84c045ac435ab29"
  license "Apache-2.0"

  livecheck do
    url "https:search.maven.orgremotecontent?filepath=orgopenapitoolsopenapi-generator-climaven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)<version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2abe5282b48695578a8460b026bc45810371623229cb94b513b38da2db2d7d43"
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