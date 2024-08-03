class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https:swagger.iotoolsswagger-codegen"
  url "https:github.comswagger-apiswagger-codegenarchiverefstagsv2.4.42.tar.gz"
  sha256 "7ad9bc792607cdc9e7f36dbbf97b4eb13ddee05fea3f38ae41c73ba3a3ecfd38"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(2(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7f932c1906382c5d66b01737b90786f0d10c894a9b24e0dbba1332545793cea4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "553ba432c4edc6f4f16eefdad1d166a4e794ab7bcf8efc3a5dd5b355cb07a7ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44f6b2fa10e30778b4a53d25e4f24d7179db74e4602a6e403f65b0a30ac8b291"
    sha256 cellar: :any_skip_relocation, sonoma:         "c55d12a869bc298a4c0a278ecd7e85cd498f659eb5658a7beac7f658e733dce1"
    sha256 cellar: :any_skip_relocation, ventura:        "cb35cdb68d93b27998c2e1f2329e36bca943b06bbac3280077f5a2e573494053"
    sha256 cellar: :any_skip_relocation, monterey:       "5127fce6ac164bc8488fcb1ad16d4cf6a105a9bb386c62e7a0eadb4651ced2fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a45f94fc4850d9ec5e3e5a6962250785589b86b1090d0deca74a96580d98b91c"
  end

  keg_only :versioned_formula

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
      swagger: '2.0'
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

    system bin"swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "html2"
    assert_includes (testpath"index.html").read, "<h1>Simple API<h1>"
  end
end