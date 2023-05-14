class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/b7/8b/ac00e4b615aea76c3b3d61592791ed739468ab6d27e314f6ad24e02bdd0f/pyinstaller-5.11.0.tar.gz"
  sha256 "cb87cee0b3c81ccd74d4bf3f4faf03b5e1e39bb91f1a894b2ce4cd22363bf779"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49c976ebaa2c270ab0dc0dc2eafd74efc0047fed598a82e64359e698f69ed5b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d1a3d9bd54000b640c01b0f604fa9d85b80ec93b6bb51545c463db2c72c5d5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7a574cc0746c7c7088b75104479e591db9bdffc7e28a17de4ea695bef722551"
    sha256 cellar: :any_skip_relocation, ventura:        "27e5d45bd56a6e0875effe6da01647315cb3239817fe521ce5e4797ed46b8e9c"
    sha256 cellar: :any_skip_relocation, monterey:       "05f1e3dfb6c4d4db85b372ab944ca6792756c066b13d8e38015471be47e209e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d23121e5d53b62e1d129759f353182c77f40ec21a0ea78891eb6fbea67c6421"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b262b56155d4cdccf902c1311550e666e5daefcd95475b7443714472e094950d"
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
    url "https://files.pythonhosted.org/packages/2b/12/4a8ccd4d5b9aa317854f5070ba0df2e269b6ceb30efd7acf13dd887d4c0b/pyinstaller-hooks-contrib-2023.3.tar.gz"
    sha256 "bb39e1038e3e0972420455e0b39cd9dce73f3d80acaf4bf2b3615fea766ff370"
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