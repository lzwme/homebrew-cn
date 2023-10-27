class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://ghproxy.com/https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v3.0.50.tar.gz"
  sha256 "7a80975088a6357716ee78a03ba146d316fa85eeae732d4484ad82230a83b9c6"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1216f62c881c698fbde6a3c0214c8eeb86805e524c1ea6f46fba03d9c1ba1aaf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bca5d626f831dd3c7240070471a8fea7a787756e8d39382edcf7d6f294f28467"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8de8fd05235d2f57d25eae189d030ccfa34feb65f72e4a5c185bfb385901cd59"
    sha256 cellar: :any_skip_relocation, sonoma:         "4852f29869b46a9170cee8906d32e747c615074155b8c15c20fb0d88fd425e4f"
    sha256 cellar: :any_skip_relocation, ventura:        "c5fcacc95dd578bb8103d2cc505195023ee201fa0db7ced9591f1886fb993d41"
    sha256 cellar: :any_skip_relocation, monterey:       "3cdd2a76db104423328cc7da6e1af98486d4c1c4a50df4e0291ade75ccc8ced6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93e01102072eda1e65ef9d3730a4a48a3dee648698505cd63eaa29bc749eff0f"
  end

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
      openapi: 3.0.0
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
    system "#{bin}/swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "html"
    assert_includes File.read(testpath/"index.html"), "<h1>Simple API</h1>"
  end
end