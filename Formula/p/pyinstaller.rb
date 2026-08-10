class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/05/03/669d06735cf57d7e2e5dfc3c2e1643554b34c559eff21449c58172ca0335/pyinstaller-6.22.0.tar.gz"
  sha256 "8b0166fff4583b374bbe7fa044bf03ddc33cab0f792a665807d96048e63f060e"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d5d1bcb5baf4dca875d36ed50956ceb85acb5f6688cff8bcd4ff09d41169390"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "081bf81eb145e006c589ec30b6a0af09081bc46d69075a546eb3928d2c42766c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1daaadf7a4f8036ee0efd6cf5a35d9c9eb23ee79f95373a505275cbab7fb8fa8"
    sha256 cellar: :any_skip_relocation, tahoe:         "d9902468232c899e4ea947b8539cc73c5987eba80ede001b6c635502ba7b4753"
    sha256 cellar: :any_skip_relocation, sequoia:       "941c9bef757ee01d73893a36f36aa6abe4bafbdb81867018f3fe0d4d701b4ace"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4ab5f9d88ab74afbac6f6d9f55fab962337378046bebbe5dfdd7b9f1ac61bb5"
    sha256 cellar: :any,                 arm64_linux:   "183ca140b5be370f4f3e6b98a81785bd0e3005fe470c684c5798764bcd4a9e4b"
    sha256 cellar: :any,                 x86_64_linux:  "827d3c11173a696d1bb0cf1f4b1074fe855861ef031d22b6eb26775b6c12636b"
  end

  depends_on "python@3.14"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  pypi_packages extra_packages: "macholib"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/7e/f8/97fdf103f38fed6792a1601dbc16cc8aac56e7459a9fff08c812d8ae177a/altgraph-0.17.5.tar.gz"
    sha256 "c87b395dd12fabde9c99573a9749d67da8d29ef9de0125c7f536699b4a9bc9e7"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/10/2f/97589876ea967487978071c9042518d28b958d87b17dceb7cdc1d881f963/macholib-1.16.4.tar.gz"
    sha256 "f408c93ab2e995cd2c46e34fe328b130404be143469e41bc366c807448979362"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/94/5b/c9fe0db5e83ee1c39b2258fa21d23b15e1a60786b6c5990ee5074ead8bb6/pyinstaller_hooks_contrib-2026.6.tar.gz"
    sha256 "bef5002c32f4f50bd55b005da12cff64eca8783e7eaf86a06a62410164bab725"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/34/26/f5d29e25ffdb535afef2d35cdb55b325298f96debd670da4c325e08d70f4/setuptools-83.0.0.tar.gz"
    sha256 "025bccbbf0fa05b6192bc64ae1e7b16e001fd6d6d4d5de03c97b1c1ade523bef"
  end

  def install
    cd "bootloader" do
      system "python3.14", "./waf", "all", "--no-universal2", "STRIP=/usr/bin/strip"
    end
    without = ["macholib"] unless OS.mac?
    virtualenv_install_with_resources(without:)
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