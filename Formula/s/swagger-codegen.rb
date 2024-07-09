class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https:swagger.iotoolsswagger-codegen"
  url "https:github.comswagger-apiswagger-codegenarchiverefstagsv3.0.58.tar.gz"
  sha256 "3f8a30e56906d78adee823daa09c731598de37a6e63c6623416b8e64b178ac5a"
  license "Apache-2.0"
  head "https:github.comswagger-apiswagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81c2fcc73b6c4cbdfef3951e9b56a3c0c512f289ab4ed960c777a5a67fa2175c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f44c2cb8354071b8d23c5fdefbe3853aef5ebfd373909f424a39d5f9a7693c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "645bddef86f44460d1c1ddfba443592c4e17dd169a3f32859e8b5dabbcff830b"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c5d6214bda900bb695860546ed762e46e5a291698904ec09f4ae2e1c18a5bf0"
    sha256 cellar: :any_skip_relocation, ventura:        "26105c6073b264d919a4cd354573a92bc3cd485a31ea995a0537bb2cb42f68dd"
    sha256 cellar: :any_skip_relocation, monterey:       "88f99d7e38ca02d387427a2fbfd9d46b0fd01fb23617876a6f2343fde7fe24cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f7c7f0dca2f022805866a0c2eec05edf08e7593c35f2678d81948534e002654"
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