class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https:pyinstaller.org"
  url "https:files.pythonhosted.orgpackages3ec87acd0d98bc71585a2ca08b959951a4a76d5289c9bef3d40ed434694a3ee4pyinstaller-6.7.0.tar.gz"
  sha256 "8f09179c5f3d1b4b8453ac61adfe394dd416f9fc33abd7553f77d4897bc3a582"
  license "GPL-2.0-or-later"
  head "https:github.compyinstallerpyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1c576e1415348867408f6d9d2b2beb1324023ed10ff16465afbf543b9c6ac4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2544f00ed3d1076c923f1132cf205e24d9c9657c787ae51b9519383ab193d5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "114c302eb15ef7aa5448a28ac90afaaeab31616757da82aca240e42b0414fb9d"
    sha256 cellar: :any_skip_relocation, sonoma:         "a17b75939a62ca0b790f01df91d93bdb7fe3146cbeafec9c8c9a46dd2df91ba1"
    sha256 cellar: :any_skip_relocation, ventura:        "44128c2d04ca865f48a6c0f0f50cc1b752a24efe515a68d8a5bc1f8e4f85d579"
    sha256 cellar: :any_skip_relocation, monterey:       "69d43b355b8ada4fcd5f5bb59d6a31e202fda675e09761b34bd0bbc06c2d2c50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ac3f7a74314a7e2b25ba978d6d4af9de48f5a02dc3610fc0d5d020aaf25b2c8"
  end

  depends_on "python@3.12"

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
    url "https:files.pythonhosted.orgpackageseeb5b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4dpackaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https:files.pythonhosted.orgpackages9ab1ea0917424a3f1b4ed760957415c5d02c081a4621300f89bd9caa9ff27b2epyinstaller_hooks_contrib-2024.6.tar.gz"
    sha256 "3c188b3a79f5cd46d96520df3934642556a1b6ce8988ec5bbce820ada424bc2b"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesaa605db2249526c9b453c5bb8b9f6965fcab0ddb7f40ad734420b3b421f7da44setuptools-70.0.0.tar.gz"
    sha256 "f211a66637b8fa059bb28183da127d4e86396c991a942b028c6650d4319c3fd0"
  end

  def install
    cd "bootloader" do
      system "python3.12", ".waf", "all", "--no-universal2", "STRIP=usrbinstrip"
    end
    virtualenv_install_with_resources
  end

  test do
    (testpath"easy_install.py").write <<~EOS
      """Run the EasyInstall command"""

      if __name__ == '__main__':
          from setuptools.command.easy_install import main
          main()
    EOS
    system bin"pyinstaller", "-F", "--distpath=#{testpath}dist", "--workpath=#{testpath}build",
                              "#{testpath}easy_install.py"
    assert_predicate testpath"disteasy_install", :exist?
  end
end