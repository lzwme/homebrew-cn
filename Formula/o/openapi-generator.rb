class OpenapiGenerator < Formula
  desc "Generate clients, server & docs from an OpenAPI spec (v2, v3)"
  homepage "https:openapi-generator.tech"
  url "https:search.maven.orgremotecontent?filepath=orgopenapitoolsopenapi-generator-cli7.7.0openapi-generator-cli-7.7.0.jar"
  sha256 "3a757276c31d249a4f06a14651b1ff1f1a5cf46e110a70adcc4a6a2834f85561"
  license "Apache-2.0"

  livecheck do
    url "https:search.maven.orgremotecontent?filepath=orgopenapitoolsopenapi-generator-climaven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)<version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ecbf5974bd48dda81026ae86c5d1ee1e6ba6fc3694e049077c837c1a5743b15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ecbf5974bd48dda81026ae86c5d1ee1e6ba6fc3694e049077c837c1a5743b15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ecbf5974bd48dda81026ae86c5d1ee1e6ba6fc3694e049077c837c1a5743b15"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ecbf5974bd48dda81026ae86c5d1ee1e6ba6fc3694e049077c837c1a5743b15"
    sha256 cellar: :any_skip_relocation, ventura:        "4ecbf5974bd48dda81026ae86c5d1ee1e6ba6fc3694e049077c837c1a5743b15"
    sha256 cellar: :any_skip_relocation, monterey:       "4ecbf5974bd48dda81026ae86c5d1ee1e6ba6fc3694e049077c837c1a5743b15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "827ddcf2e4374c10042617244d52fd18c4a3bb91f82abc6b8b1950593b1c1653"
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