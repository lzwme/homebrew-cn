class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/21/a7/f3caf846fcba1a840074b843e948272393f4458e9a709a511ce7e43e8ed5/pyinstaller-5.13.1.tar.gz"
  sha256 "a2e7a1d76a7ac26f1db849d691a374f2048b0e204233028d25d79a90ecd1fec8"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9179c02e586edef952fba16dccc2037e9c7e69bdadcc94fc33f4ee3a31c52f16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edb9c26100435f38f4c817108986de17eb5b64d15fb44043e67e462abbcebe48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37b1a75fe72a7df8862d0f706950662e032620fc33c1e33af2b3e066b18f20d6"
    sha256 cellar: :any_skip_relocation, ventura:        "fc78aa9580b4bbbeea48b9ccd34dc240af0f36597fc6e2e020c6da81d35ff58b"
    sha256 cellar: :any_skip_relocation, monterey:       "d78d729f43a3e88001877df3aef2212b6fb5852183965b6a6445e1a8adc1e2c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6910d3e9f55aac48a727c6cbe48f54708152f7f7eb3a1e719bc6be704725e8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d05f5f45c0bfd451ec42ff0124d5520e7a140952a83150a1b87b064ab9ff2357"
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
    url "https://files.pythonhosted.org/packages/38/81/d81344cc66ecb19c15d0b858598347fc0541278c241a96669543fb7519f6/pyinstaller-hooks-contrib-2023.7.tar.gz"
    sha256 "0c436a4c3506020e34116a8a7ddfd854c1ad6ddca9a8cd84500bd6e69c9e68f9"
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