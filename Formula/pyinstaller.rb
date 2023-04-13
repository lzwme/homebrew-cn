class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/0f/22/80d551593c1429a7f56680eecffe9b1c7e2b47b0d3a82feaa35fa5efeb74/pyinstaller-5.10.0.tar.gz"
  sha256 "4ae664b93b627b717c23b90e8deae64f23ffb2f62197abdb87def44512c7e759"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08c6dc8dc0d6f10123506f38da5db0c470dd7973c8aab27f28a67d25a4c447ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96a6f63a0b618509aa6bc9cee9d123959f31fab80af95e50c29fce03249d26a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68bf94801b846e8d3768f31e9a71cffaf16061b89e64bb6b2628833bea50dd98"
    sha256 cellar: :any_skip_relocation, ventura:        "39b90f2c95553d2cd7c2f42094cbfa317413dadad9e0e5d288b281999891b4a0"
    sha256 cellar: :any_skip_relocation, monterey:       "46b9c601c18bf951fe9f2a90c4ade1fa654c153069c19e51c9ef6df406ff553f"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a7091cbca19f58926d26381e53bda1438bad7f8e6ef544e9b3ab0c9ba69fe54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15ff4ff0a2fdd73d2079c5611320f48b829cd525137909de590498a32db02e3b"
  end

  depends_on "python@3.11"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/5a/13/a7cfa43856a7b8e4894848ec8f71cd9e1ac461e51802391a3e2101c60ed6/altgraph-0.17.3.tar.gz"
    sha256 "ad33358114df7c9416cdb8fa1eaa5852166c505118717021c6a8c7c7abbd03dd"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/46/92/bffe4576b383f20995ffb15edccf1c97d2e39f9a8c72136836407f099277/macholib-1.16.2.tar.gz"
    sha256 "557bbfa1bb255c20e9abafe7ed6cd8046b48d9525db2f9b77d3122a63a2a8bf8"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/67/22/2f49f4693bc7db9f2ee7a05a3c04f255b3db4251a0f1ff003b8ab9f87ff4/pyinstaller-hooks-contrib-2023.2.tar.gz"
    sha256 "7fb856a81fd06a717188a3175caa77e902035cc067b00b583c6409c62497b23f"
  end

  def install
    cd "bootloader" do
      system "python3.11", "./waf", "all", "--no-universal2", "STRIP=/usr/bin/strip"
    end
    virtualenv_install_with_resources
  end

  test do
    (testpath/"easy_install.py").write <<~EOS
      """Run the EasyInstall command"""

      if __name__ == '__main__':
          from setuptools.command.easy_install import main
          main()
    EOS
    system bin/"pyinstaller", "-F", "--distpath=#{testpath}/dist", "--workpath=#{testpath}/build",
                              "#{testpath}/easy_install.py"
    assert_predicate testpath/"dist/easy_install", :exist?
  end
end