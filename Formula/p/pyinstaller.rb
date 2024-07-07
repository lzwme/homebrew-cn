class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https:pyinstaller.org"
  url "https:files.pythonhosted.orgpackages66294bb2eb120b859b5691db5487777a9f1ed63a4b62d6df68284268074f7b73pyinstaller-6.9.0.tar.gz"
  sha256 "f4a75c552facc2e2a370f1e422b971b5e5cdb4058ff38cea0235aa21fc0b378f"
  license "GPL-2.0-or-later"
  head "https:github.compyinstallerpyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a8ce32f346724def4ee359e6096f720c6ce7f83ace2dc419fbb31ccf696af58"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f29218bd453e34035de85a781ddc78e02c91651598e9979d5d0b9f5870487d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab10f938b826b1c9beeb78c098c8bebace6493d4a1ab71ea49aafb2b9626ca0b"
    sha256 cellar: :any_skip_relocation, sonoma:         "4180cc0f03159856292c850f06c76eb1af87a72caa0c4d0e21c59d90ea19ff15"
    sha256 cellar: :any_skip_relocation, ventura:        "4e4a9fb4042e7cc26f82292f6cbb6fbdad32cc4a900361fa0b6e07196c0fcd69"
    sha256 cellar: :any_skip_relocation, monterey:       "ebee855d5be0fdd45664134c3c53e355ece78c69384d5e81df75a37412b05348"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d0ca3f4a9d73c513c89a872ddb309718edae0758fff5a603b40c465bd09b6e6"
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
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https:files.pythonhosted.orgpackagesb104fd321018585c0751e8a4f857470e95d188aa80bc48002303cf26e5711d7dpyinstaller_hooks_contrib-2024.7.tar.gz"
    sha256 "fd5f37dcf99bece184e40642af88be16a9b89613ecb958a8bd1136634fc9fac5"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages8de62fc95aec377988ff3ca882aa58d4f6ab35ff59a12b1611a9fe3075eb3019setuptools-70.2.0.tar.gz"
    sha256 "bd63e505105011b25c3c11f753f7e3b8465ea739efddaccef8f0efac2137bac1"
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