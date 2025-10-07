class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://ghfast.top/https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v3.0.74.tar.gz"
  sha256 "a6b01a467011130d6d6addc2c595a5b5bc179918a77d2ac682f1940081370fdc"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ff35d66db4f58cb36521b85bcddd8a3c7c56fa92f34f3f99ebc43921119959c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b829123f69087c5a41da36212c4bf34ff2bd34510a4c9762376968772d7ac03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0de8fba98673d146a059cd0597894623732f28ffcbfda1ee1f0bf55e97b01ad0"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdd0b16147f160f47835019cb7a321fdff35c09b8f9a6f85978b43387121faf0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd9b5216a528d5173f1bb1d69ec4cd8079157eead1a9d86ab21abb44a293cc7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02a4aa9e5e702af4c13da688b1681916686ad725f591b08f8cf8fd577f49d58f"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    # Need to set JAVA_HOME manually since maven overrides 1.8 with 1.7+
    ENV["JAVA_HOME"] = Language::Java.java_home

    system "mvn", "clean", "package"
    libexec.install "modules/swagger-codegen-cli/target/swagger-codegen-cli.jar"
    bin.write_jar_script libexec/"swagger-codegen-cli.jar", "swagger-codegen"
  end

  test do
    (testpath/"minimal.yaml").write <<~YAML
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
    YAML
    system bin/"swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "html"
    assert_includes File.read(testpath/"index.html"), "<h1>Simple API</h1>"
  end
end