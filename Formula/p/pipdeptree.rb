class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https:github.comtox-devpipdeptree"
  url "https:files.pythonhosted.orgpackagesd54ca9e8e5820f066185f392e64bd4a5335d5bdbe5d26871985f1122fb1c53efpipdeptree-2.23.3.tar.gz"
  sha256 "3fcfd4e72de13a37b7921bc160af840d514738f9ea81c3f9ce080bc1e1f4eb5a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7129ab38c2f685bcf4687ef2a4449c428c8151bc0feee267ed85e29e3586261c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1045634cc4746ed79772f79344ad9ae2e0cb523c680ab08301d7383f95d18642"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1045634cc4746ed79772f79344ad9ae2e0cb523c680ab08301d7383f95d18642"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1045634cc4746ed79772f79344ad9ae2e0cb523c680ab08301d7383f95d18642"
    sha256 cellar: :any_skip_relocation, sonoma:         "958032413b69e1bc4da4ba93c936139c858d6b451b74d72ec7fca6721d481216"
    sha256 cellar: :any_skip_relocation, ventura:        "958032413b69e1bc4da4ba93c936139c858d6b451b74d72ec7fca6721d481216"
    sha256 cellar: :any_skip_relocation, monterey:       "958032413b69e1bc4da4ba93c936139c858d6b451b74d72ec7fca6721d481216"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1045634cc4746ed79772f79344ad9ae2e0cb523c680ab08301d7383f95d18642"
  end

  depends_on "python@3.12"

  resource "packaging" do
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}pipdeptree --all")

    assert_empty shell_output("#{bin}pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}pipdeptree --version").strip
  end
end