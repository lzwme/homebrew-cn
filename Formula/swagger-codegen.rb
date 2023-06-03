class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://ghproxy.com/https://github.com/swagger-api/swagger-codegen/archive/v3.0.45.tar.gz"
  sha256 "a0b43a96405d2973fc0432f1366a0c7db1fdefcc6e7f50b92f1f1e20e9f5c7d0"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c189dd76cf470833a893b853c0075766e0c2bbbab0dba908a4b8d65ae4e1ac62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da00504c1f969ea2915c7efae003c9a263da0a516b64d48009f7907cbbde1013"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f5e1bb4aa2c1083e38124b98ac6206b4be149dcce3ff777f0b4027e4dbdfefd"
    sha256 cellar: :any_skip_relocation, ventura:        "0a7c06f55ea608b83fb38cc6da8dc5cec8f2a27504bc6571525da78debc50f91"
    sha256 cellar: :any_skip_relocation, monterey:       "6e4ef51fdd65abb0858e63cfd1fabd9aa28e7f857d51a52b0790bca766ed75cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5971250fa2d62bd5f215678096c6a6c709f6da49c56d047b661159f0bb96b8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d027c17105892bd605c982a0958a74384a3f163c26e2cef4dc6280f6f702511"
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