class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https:swagger.iotoolsswagger-codegen"
  url "https:github.comswagger-apiswagger-codegenarchiverefstagsv3.0.64.tar.gz"
  sha256 "944a1c119822754c95f6d11fe44c18ea8dbe05c2ddf84f1c34024d19454f33fc"
  license "Apache-2.0"
  head "https:github.comswagger-apiswagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "806b27e63561d473c3d9590096a90bae7a98445f6270e4a4841d513ca07919a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2e0ae5135bc4def24dc66d7d80ff0b9a95ab1c0bc18df23b2b68bd881ae095e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cced6ccf506f0f11ad477732b66b37aa6d954eb69c72a68864749a67cff3bcb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "1be903f02292e44dd6d5605a21736a0f80c2e1121a40b96dd8d3b532f5bc49a7"
    sha256 cellar: :any_skip_relocation, ventura:       "eb1323ba442f209716969501dc87b0a972cab829f9e765bca089bbcea9eebb51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3b4f7db9a0a56b216652e41c1a677ca808cc1b84d03db7de63020e920b448dd"
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
    (testpath"minimal.yaml").write <<~EOS
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
    EOS
    system bin"swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "html"
    assert_includes File.read(testpath"index.html"), "<h1>Simple API<h1>"
  end
end