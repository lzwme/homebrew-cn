class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/tools/swagger-codegen/"
  url "https://ghfast.top/https://github.com/swagger-api/swagger-codegen/archive/refs/tags/v3.0.72.tar.gz"
  sha256 "3cd134517e756e93c130ea5be2924742d6b04c4e46315090d286e601aa6bbd83"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8149a6e3ca75b2588fb0a0408ac859fa80406ec1e2ac2eadb47ba68146a5f22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d834e80cad55d44f0273fb4cd4b58f39470cd5eac207f9de3969745a48377fc4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "425bcfdc48c1998688fc40042ae042b02724c0045f00572daf7c7f7c0ee2f861"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a438e0ba44df96d0a574a7181142436933b322b753256d5d52054b51457440a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d0b335006a965110d475181721838df159cab4c7727b1243cc07a16e8810048"
    sha256 cellar: :any_skip_relocation, ventura:       "6c09ffefcd6fa028742c5d849d8f749eea392323a39a3ecf6778863bad33dfc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc9346205d7254c9c4c7bd9ca5c1befa602bc9410d6ad8cf832c94d1a3fb94f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15d21ec68834248a48a695050276531fd5b496b6bb2d81b3368bdc8ea7cc9a8b"
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