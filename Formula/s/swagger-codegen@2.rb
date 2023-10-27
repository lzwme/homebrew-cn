class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://ghproxy.com/https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v2.4.36.tar.gz"
  sha256 "f66d8e786a471de570c6cf6ce6eb653b7dbd2b5a0f06e10ac531c969da70889c"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/swagger-api/swagger-codegen.git"
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dcb36dd2e7381620ac55777ffd20958272631131c8434e8e4a42525a056433c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4b3d4ff80aedb53d865aa784e908e68423b1b0d60445ea6a120837453af78d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c92a7f926540078d294f38208e789ae5208195de7a08f55376d093f5f4be14b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d36acb0398d134ce0dc2e2b0900a08bb6a8351ad09367105ad746d056c5e729"
    sha256 cellar: :any_skip_relocation, ventura:        "072aa10c76b49c192fff6a1d0f343541ce6b17c7b0a119633272753a98d0dbfb"
    sha256 cellar: :any_skip_relocation, monterey:       "05dd1b578a32355290095d4bbf733db9fd5f6dd1acab9291114810027e4a0f87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "699bc63c3cfb249234b8ae9311c1346dc2bd839933e265921a3f5970b35ad6e7"
  end

  keg_only :versioned_formula

  depends_on "maven" => :build
  depends_on "openjdk@11"

  def install
    # Need to set JAVA_HOME manually since maven overrides 1.8 with 1.7+
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix

    system "mvn", "clean", "package"
    libexec.install "modules/swagger-codegen-cli/target/swagger-codegen-cli.jar"
    bin.write_jar_script libexec/"swagger-codegen-cli.jar", "swagger-codegen", java_version: "11"
  end

  test do
    (testpath/"minimal.yaml").write <<~EOS
      ---
      swagger: '2.0'
      info:
        version: 0.0.0
        title: Simple API
      paths:
        /:
          get:
            responses:
              200:
                description: OK
    EOS
    system "#{bin}/swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "html2"
    assert_includes File.read(testpath/"index.html"), "<h1>Simple API</h1>"
  end
end