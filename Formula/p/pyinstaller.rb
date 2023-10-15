class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/89/85/6c14b541f8e9b61eef5eafba3630d68ea0598f6a4cf531c23189765e9bb5/pyinstaller-6.1.0.tar.gz"
  sha256 "8f3d49c60f3344bf3d4a6d4258bda665dad185ab2b097341d3af2a6387c838ef"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "31417be402844ac286287843ee86fc57d5f3dca8198979c351d321de8532d9a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1aab0ea79ec25ffd84b4afc441a3b76277b12a4faf8337271b8775ae0ca3a9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f651d1e854168258dbd53db82902dbada392ae7da344c0b5c1ff992fc98c48b"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb2195b95843e68ffc4caf008a49ff3d929800d5e50d6335965b5e53eb5bf221"
    sha256 cellar: :any_skip_relocation, ventura:        "10f15ebbdca2394d557000ca2fc2e6054ee67b26daa7c974265d006fe10e887a"
    sha256 cellar: :any_skip_relocation, monterey:       "71eb1fa554eec785e356d28cc09c40ecbf21246709bb459dcf83c0878241dfdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8aa832e07e69348612bbaeeb0c366c7ebc0039dee6794bceb7368c4504992b6b"
  end

  depends_on "python-packaging"
  depends_on "python@3.11"

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