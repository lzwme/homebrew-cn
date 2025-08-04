class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/64/17/b2bb4de22650adbeef401fa82a1b43028976547a8728602e4d29735b455e/pyinstaller-6.15.0.tar.gz"
  sha256 "a48fc4644ee4aa2aa2a35e7b51f496f8fbd7eecf6a2150646bbf1613ad07bc2d"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5ff41f430f11af6a4c0390799a222da99e34645da7bc8813b2a7568078cf1dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62303fc7fdf52d69ca78d361d23c3b048252b81de49f769aa2b756528084301d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c645d5a3f6f87616c6ba06e93658ae1a571e0676756aeae080d48f2ca9fb4574"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e873b7f7cb31f19bdb1f0441072e2bf87ff266657a184b58b4ece1e4a67d806"
    sha256 cellar: :any_skip_relocation, ventura:       "c3e108d0ce65fc0db29fa84bf2f08e8960830e1da9d8928b2016f83efd35358d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "635936c2b4036e7ca6ef706efdeb50e6dc5118fbef8c335efa8cbe39828c3151"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "035e1c7afeeeb0ea425b8c9cdee09c671568cfc12554405c227aa166a9a928ce"
  end

  depends_on "python@3.13"

  uses_from_macos "zlib"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/de/a8/7145824cf0b9e3c28046520480f207df47e927df83aa9555fb47f8505922/altgraph-0.17.4.tar.gz"
    sha256 "1b5afbb98f6c4dcadb2e2ae6ab9fa994bbb8c1d75f4fa96d340f9437ae454406"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/95/ee/af1a3842bdd5902ce133bd246eb7ffd4375c38642aeb5dc0ae3a0329dfa2/macholib-1.16.3.tar.gz"
    sha256 "07ae9e15e8e4cd9a788013d81f5908b3609aa76f9b1421bae9c4d7606ec86a30"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/71/d6/e5b378b7d4add8c879295c531309b0320e9c07a70458665d091760ffdc87/pyinstaller_hooks_contrib-2025.8.tar.gz"
    sha256 "3402ad41dfe9b5110af134422e37fc5d421ba342c6cb980bd67cb30b7415641c"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  def install
    cd "bootloader" do
      system "python3.13", "./waf", "all", "--no-universal2", "STRIP=/usr/bin/strip"
    end
    virtualenv_install_with_resources
  end

  test do
    (testpath/"easy_install.py").write <<~PYTHON
      """Run the EasyInstall command"""

      if __name__ == '__main__':
          from setuptools.command.easy_install import main
          main()
    PYTHON
    system bin/"pyinstaller", "-F", "--distpath=#{testpath}/dist", "--workpath=#{testpath}/build",
                              "#{testpath}/easy_install.py"
    assert_path_exists testpath/"dist/easy_install"
  end
end