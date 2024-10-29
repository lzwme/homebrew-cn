class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-8.7.2.tgz"
  sha256 "40e76b92b56f34ba18b6fb7aae5c4aef34564e394dbdb90c9633ed40fb505c6b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "37b79e53a7eb77e931ca74954c4be143e97e6509808057974831bd61b9ca9bc8"
    sha256 cellar: :any,                 arm64_sonoma:  "37b79e53a7eb77e931ca74954c4be143e97e6509808057974831bd61b9ca9bc8"
    sha256 cellar: :any,                 arm64_ventura: "37b79e53a7eb77e931ca74954c4be143e97e6509808057974831bd61b9ca9bc8"
    sha256 cellar: :any,                 sonoma:        "a529050acb3681d924eaf66dcc4bc2af3f6c38d827505e8166bf36c4cb4d8a2d"
    sha256 cellar: :any,                 ventura:       "a529050acb3681d924eaf66dcc4bc2af3f6c38d827505e8166bf36c4cb4d8a2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35f3942f8a4ca2681553c20e79e0ca2c77b6a712a0b8c9dcee49fa97130f2743"
  end

  depends_on "node"
  depends_on "openjdk"

  def install
    system "npm", "install", *std_npm_args
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    output = shell_output("#{bin}/jhipster info 2>&1")
    assert_match "JHipster configuration not found", output
    assert_match "execution is complete", output

    assert_match version.to_s, shell_output("#{bin}/jhipster --version")
  end
end