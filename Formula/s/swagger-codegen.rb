class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https:swagger.iotoolsswagger-codegen"
  url "https:github.comswagger-apiswagger-codegenarchiverefstagsv3.0.69.tar.gz"
  sha256 "65a9c70119afaf3d780f9f50c75cf178c4f9a294adc0183749a36e2e9aa3d580"
  license "Apache-2.0"
  head "https:github.comswagger-apiswagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcae575890a52edf9ea29199558dbc51ebbb3a4daca69121364b561d76153e78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6e6bc84d97c4364689689da1d11cc0c5b1876272c20baa9fa893ba9938d5e08"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5bf6233172f6c672a5f1188b825a005d73d33f25868b4c456952d5a330e1b830"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4c4bc297e6404719495baa7302dfde7739274dd62c9238562258d59a0f6e8c8"
    sha256 cellar: :any_skip_relocation, ventura:       "fb340797bc5539dceec003b2d64d7c28720f77883f97142a05d2287bd52efb9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a469dfc63e8c239cdb4be7aea11973b510b56cb865ca662ea26a42432927165f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d48f8c2c0026cb0bb96aa6f2a37258d350e3f4d47232a0aefe21b32638bf4c10"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    # Need to set JAVA_HOME manually since maven overrides 1.8 with 1.7+
    ENV["JAVA_HOME"] = Language::Java.java_home

    system "mvn", "clean", "package"
    libexec.install "modulesswagger-codegen-clitargetswagger-codegen-cli.jar"
    bin.write_jar_script libexec"swagger-codegen-cli.jar", "swagger-codegen"
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