class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://ghproxy.com/https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v2.4.37.tar.gz"
  sha256 "a0cefd9a27c683396a105a605d38fd1950af7b64c7a1d2138c847067398fc6f9"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/swagger-api/swagger-codegen.git"
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "754e0e9ee7efaacb0532c27f237e1089b33cad06a14d01d48d322752d91ebea8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46ebb83e278d675a47f883944e67e120e88cd891e72ca2f15ff985fd1b5a4a41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28783a8b1c471e93e5a1c90061ed3dc1d4288c81635c7fff42d99d1cd4a650aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "5472ac134dfc2301ee161cdbe918f2bbc6b9627ea9873acda5cd42f7182577da"
    sha256 cellar: :any_skip_relocation, ventura:        "ee819705c5bf8de828d19dc1d0e8e64fd8608860849aa39b97aff8b07f00a4e0"
    sha256 cellar: :any_skip_relocation, monterey:       "9a2d5ff3a2287a9df9f0ad685d309e843e8df66cc2f57fbf5304fb175b41f10f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2aed8996d447ddf63598e7ecca09dd6665237611d114c178f2b33f7b331ea9b"
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