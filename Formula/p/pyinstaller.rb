class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https:pyinstaller.org"
  url "https:files.pythonhosted.orgpackages7edc4ec9284d14952d3a4902c29b0c86314cad8de35104b5c1d6e001b914c0f5pyinstaller-6.14.0.tar.gz"
  sha256 "cc55cdc21491722d74133e35ab363a88679b37ee2d76f9d80adcbc0ae862d630"
  license "GPL-2.0-or-later"
  head "https:github.compyinstallerpyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40ddcdd453940a6f1077e5ec2dc19347fefcad6968e5e3539ea92ace800636ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a15f1ac2162bab20c33a65d1c027a6605b9befc1ca2d453be760fa4a7cdc6c89"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "21bcdb8255e236dc7873e9fda9504f2df86c5e6383a5e93e74c5db4ca3ec3671"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c3060dd927479cfe1ef8a220e48fa185bb5f053b64c3258bac6d2c260a3ec43"
    sha256 cellar: :any_skip_relocation, ventura:       "a1720f76fc3aa2c31dd5d017d70fe1bd192d5ad9669c1792a5a6e75eacbe0abf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "213b08559967bae95ad7b92e9bfcdade5aef39805489b320cacf141c6dcea688"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef323eb36cf68a82a9d1e2ab496bada2dc500bdd47779edd144abe5afa6d466a"
  end

  depends_on "python@3.13"

  uses_from_macos "zlib"

  resource "altgraph" do
    url "https:files.pythonhosted.orgpackagesdea87145824cf0b9e3c28046520480f207df47e927df83aa9555fb47f8505922altgraph-0.17.4.tar.gz"
    sha256 "1b5afbb98f6c4dcadb2e2ae6ab9fa994bbb8c1d75f4fa96d340f9437ae454406"
  end

  resource "macholib" do
    url "https:files.pythonhosted.orgpackages95eeaf1a3842bdd5902ce133bd246eb7ffd4375c38642aeb5dc0ae3a0329dfa2macholib-1.16.3.tar.gz"
    sha256 "07ae9e15e8e4cd9a788013d81f5908b3609aa76f9b1421bae9c4d7606ec86a30"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesa1d41fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24dpackaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https:files.pythonhosted.orgpackagese394dfc5c7903306211798f990e6794c2eb7b8685ac487b26979e9255790419cpyinstaller_hooks_contrib-2025.4.tar.gz"
    sha256 "5ce1afd1997b03e70f546207031cfdf2782030aabacc102190677059e2856446"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages185d3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fcasetuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  def install
    cd "bootloader" do
      system "python3.13", ".waf", "all", "--no-universal2", "STRIP=usrbinstrip"
    end
    virtualenv_install_with_resources
  end

  test do
    (testpath"easy_install.py").write <<~PYTHON
      """Run the EasyInstall command"""

      if __name__ == '__main__':
          from setuptools.command.easy_install import main
          main()
    PYTHON
    system bin"pyinstaller", "-F", "--distpath=#{testpath}dist", "--workpath=#{testpath}build",
                              "#{testpath}easy_install.py"
    assert_path_exists testpath"disteasy_install"
  end
end