class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/dd/c8/7bbbb6bb4130f96f7bc32064c13f115546fce07a3aacae75c3b4142256bd/pyinstaller-6.2.0.tar.gz"
  sha256 "1ce77043929bf525be38289d78feecde0fcf15506215eda6500176a8715c5047"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8fd38fdf957c31d53f62b96911ce72f23a7d9da4d99dfc5aa163587c8b365dca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "222121eca136d0c20b0d3ecca77bf165ea47de57d71d2eb1cade313f23e2b2b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71bb7c7bdabdde373b427b8237f7241f661eda42b5849d8bce626898c51ead90"
    sha256 cellar: :any_skip_relocation, sonoma:         "d3383fe3a776b4e51f7afaac6b7a0f508964b7ec4eab6241a0a4d07de5299ceb"
    sha256 cellar: :any_skip_relocation, ventura:        "ae8c0536ec8acc718783559153a5204c75b1ea79fc2992e22eb1a82cec724c0d"
    sha256 cellar: :any_skip_relocation, monterey:       "98e4bc2bcb0e001e58f1b5fefe246a3e83b74aee5ba758ae5b0181b325bd5b14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6baff14e2b46f83b0de86e00bf03539e235023334e3887404b8b82997a30c157"
  end

  depends_on "python-packaging"
  depends_on "python-setuptools"
  depends_on "python@3.12"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/de/a8/7145824cf0b9e3c28046520480f207df47e927df83aa9555fb47f8505922/altgraph-0.17.4.tar.gz"
    sha256 "1b5afbb98f6c4dcadb2e2ae6ab9fa994bbb8c1d75f4fa96d340f9437ae454406"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/95/ee/af1a3842bdd5902ce133bd246eb7ffd4375c38642aeb5dc0ae3a0329dfa2/macholib-1.16.3.tar.gz"
    sha256 "07ae9e15e8e4cd9a788013d81f5908b3609aa76f9b1421bae9c4d7606ec86a30"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/3d/e0/d41437880dc87abfc28cb6ae965d113dfd9d7151ef61223b71488062a114/pyinstaller-hooks-contrib-2023.10.tar.gz"
    sha256 "4b4a998036abb713774cb26534ca06b7e6e09e4c628196017a10deb11a48747f"
  end

  def install
    cd "bootloader" do
      system "python3.12", "./waf", "all", "--no-universal2", "STRIP=/usr/bin/strip"
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