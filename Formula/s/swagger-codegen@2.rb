class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://ghproxy.com/https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v2.4.34.tar.gz"
  sha256 "99ee1e7d4f7010bfec2e3b3ae01751269d86082fdccd3959102b3c9018dc5b63"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/swagger-api/swagger-codegen.git"
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "31d5e034a8602f5a6fdd709aa3910e34ed27e7aefb18924084cb7d3c9c4a5210"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5781dc5c4c96e196903f07bcfd9f8875b763b98bf94c66a8ee08b507e7eef723"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f621f9f768ad28e72fbc5961f062a9b5b1f71db69d3ce036bd48a5e6c26f05a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec69c3db179ba6bb8cdcf04bf335109222bcb1f7d041492a4c6cdc01eca91e34"
    sha256 cellar: :any_skip_relocation, ventura:        "5bb6e03931b6bf5a707f942f1e0389f0a2c83bde8ea3263b509c9f8c4c8d2b5a"
    sha256 cellar: :any_skip_relocation, monterey:       "bcf26d32c90aa269465b1e50a3c9388d81cbe6f5ad99bc4f06aaad507eff962d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b38c8cf1c7054e2d490abaf4019e063cc4d0414de044a5ea21e3ab360ba9a543"
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