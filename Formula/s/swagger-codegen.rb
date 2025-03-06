class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https:swagger.iotoolsswagger-codegen"
  url "https:github.comswagger-apiswagger-codegenarchiverefstagsv3.0.68.tar.gz"
  sha256 "05edb52130fe8c7d619338b23693aa284138fac2e73867ce5ab718e21b34ea45"
  license "Apache-2.0"
  head "https:github.comswagger-apiswagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb6b958cecc016884b1774e63ef5f5bbcecede8ec380ca11f8256c6a42d6a336"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03d899861a15898a5f224a7f39bf333f8aab790c59a1b6d11a7275631e76ddba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "041af89bc0d6d4daac7041614c0f9b3f930d04749babeeea4840ee8eb602dc1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfda5214c52a6f4027bbd7d4034241d058e210856bc183bf2db27a94c90c6f50"
    sha256 cellar: :any_skip_relocation, ventura:       "158a8a85a960153303a40a01f20065a5dff1fe09056ea4d2da2a93e4b4f2d32c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77a1661867f9596d38e9da2ceb245be0e74590c0e632207102e1f8724a0515b8"
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
    (testpath"minimal.yaml").write <<~YAML
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
    YAML
    system bin"swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "html"
    assert_includes File.read(testpath"index.html"), "<h1>Simple API<h1>"
  end
end