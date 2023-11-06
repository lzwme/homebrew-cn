require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-8.0.0.tgz"
  sha256 "8c96f780cbae4159292d49716e675d2a97d7cdd054427fc1449684b93a16063a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ce09179c1438fcc4cc70b0d8ef7a587e1b75519a7fa78606b1a6e32c29712a14"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce09179c1438fcc4cc70b0d8ef7a587e1b75519a7fa78606b1a6e32c29712a14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce09179c1438fcc4cc70b0d8ef7a587e1b75519a7fa78606b1a6e32c29712a14"
    sha256 cellar: :any_skip_relocation, sonoma:         "b70a926bbae43c723decf4bc937e3ea97f236193cb0b44340c81ae07ed734d5d"
    sha256 cellar: :any_skip_relocation, ventura:        "b70a926bbae43c723decf4bc937e3ea97f236193cb0b44340c81ae07ed734d5d"
    sha256 cellar: :any_skip_relocation, monterey:       "b70a926bbae43c723decf4bc937e3ea97f236193cb0b44340c81ae07ed734d5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9c7c986b142ba3abee3fa8ab9f03374d50f032cf71d1f930bfac9fc351ba61a"
  end

  depends_on "node"
  depends_on "openjdk"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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