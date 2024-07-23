class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https:swagger.iotoolsswagger-codegen"
  url "https:github.comswagger-apiswagger-codegenarchiverefstagsv3.0.59.tar.gz"
  sha256 "e30fcb0a9d4e76f3e9c67da52fdc65fb6b91e7ef7cce5a0d5eca619a8f3f0bc7"
  license "Apache-2.0"
  head "https:github.comswagger-apiswagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca69da7f7e4204eb0c91154e598c35b23cc90f045b1bebcefc8b9ca7d0be5fda"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a25dc6fb087a3de6a1610fcce2aad815f95fed72396b61e757259f2f524be7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e05088fe8ab36a1703f4a1233bdd07f841e22aba1b6effe120782e56325a31fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc17827856c85524d48091e0e41a15239e1b924bab67698785a6cf57e3df12df"
    sha256 cellar: :any_skip_relocation, ventura:        "0712d6cdf9be3d0f5c5bcf0b5be3e2d90d458032454787f8ad18d95e324367e3"
    sha256 cellar: :any_skip_relocation, monterey:       "b343822e4b9a92229a39de05292765be1a2e4afb65eb553ae9a7c1ef99a42720"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2550d7e02c243260a1a626f0def4db7e903870a24271e32173b7a9cb37a77c5"
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
    system "#{bin}swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "html"
    assert_includes File.read(testpath"index.html"), "<h1>Simple API<h1>"
  end
end