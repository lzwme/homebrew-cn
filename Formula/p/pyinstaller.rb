class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https:pyinstaller.org"
  url "https:files.pythonhosted.orgpackages9f4ad66d3a9c34349d73eb099401060e2591da8ccc5ed427e54fff3961302513pyinstaller-6.14.1.tar.gz"
  sha256 "35d5c06a668e21f0122178dbf20e40fd21012dc8f6170042af6050c4e7b3edca"
  license "GPL-2.0-or-later"
  head "https:github.compyinstallerpyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2381204c2ea913f86bf2f6c3a13b5f8bde4d7e85e5d2890914ec439b9498b15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "697bf4fbb61a631b87652a1d96b3d1c321fbbb28984642579d5b1dc65a96b50e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c5cdcabc5034582eaf8bfe3e6da0a3aa0a0140b36106f32df9debb99946aa2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ad571209e7b89c777d048c7105a49f0c8f339bfd770162f98c43b3b2734ee30"
    sha256 cellar: :any_skip_relocation, ventura:       "8090c9bc363041ec4014d49bd3e38166981496e5fe216162484d7c27d86ae4ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6b4eb51ae141819b36e17fcda31f26eac61fa8b6ec264b219fb13911dc4789c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4eeac5e3a452556c7b2452b1b1ad95f47e5a4912ef831d00808a620fa5b7d7b"
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
    url "https:files.pythonhosted.orgpackages5fffe3376595935d5f8135964d2177cd3e3e0c1b5a6237497d9775237c247a5dpyinstaller_hooks_contrib-2025.5.tar.gz"
    sha256 "707386770b8fe066c04aad18a71bc483c7b25e18b4750a756999f7da2ab31982"
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