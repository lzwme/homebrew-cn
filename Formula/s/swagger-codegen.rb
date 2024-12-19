class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https:swagger.iotoolsswagger-codegen"
  url "https:github.comswagger-apiswagger-codegenarchiverefstagsv3.0.65.tar.gz"
  sha256 "6339a67657d088e22fd983ba9983e0e0cbc9dfd70a63d2138b69734cb3a02218"
  license "Apache-2.0"
  head "https:github.comswagger-apiswagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79b1cf1148fdd4301d25ab77f766bd9cfaec8a575ded68ff29470bfb5d57186f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7111b269c0ee8e129365dbe1ad6077b53d636553b72fe22c18a27ac2070f777b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c6fe63ffeff2f5757fe87225c4bf47b064323c853d7483dfa2fcabbe331f59b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d61dd724dff1947da1a0618863af425337abd13b4aad175bf652bd3e5611f234"
    sha256 cellar: :any_skip_relocation, ventura:       "4da608ab267a548124c1cd5e57311b5ee88bc4d9f396fbd682dba10414beac04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7a2da21c3f69b8f0c55d796ef7badf2ce29436bfb5c0474ea88d633a892617e"
  end

  depends_on "maven" => :build
  depends_on "openjdk@11"

  def install
    # Need to set JAVA_HOME manually since maven overrides 1.8 with 1.7+
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix

    system "mvn", "clean", "package"
    libexec.install "modulesswagger-codegen-clitargetswagger-codegen-cli.jar"
    bin.write_jar_script libexec"swagger-codegen-cli.jar", "swagger-codegen", java_version: "11"
  end

  test do
    (testpath"minimal.yaml").write <<~YAML
      ---
      openapi: 3.0.0
      info:
        version: 0.0.0
        title: Simple API
      paths:
        :
          get:
            responses:
              200:
                description: OK
    YAML
    system bin"swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "html"
    assert_includes File.read(testpath"index.html"), "<h1>Simple API<h1>"
  end
end