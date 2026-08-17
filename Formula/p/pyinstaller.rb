class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/c3/28/11937d2d139139d5645cbaf905f7dcaa9c4929bd7b740ad9157af730fd39/pyinstaller-6.22.1.tar.gz"
  sha256 "4e7ed495fccb9974d47cf72ef8cffc92afa05d60bc265c5585a68f3d229ca8d1"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3843b85d2f0be024827199bc193146ad5f7aa23a400648a4d901c0d542eb0ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "622c778b2cd8407db8d8f828be607095fc781a5cc076d474c8bd738e43363817"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7f3cdd7c21c376b6aa2e272d5c8bd6ffc18346db4ebe79269f37e7b6d117545"
    sha256 cellar: :any_skip_relocation, tahoe:         "608e7c592d3dcf7e7e310aa900dfe0c731b0de962ea3e9079c0c703e663864d9"
    sha256 cellar: :any_skip_relocation, sequoia:       "b3fa19c292fa28941c457ce7e62697ec672aaa581a0b65e1e83de55bb9ad0623"
    sha256 cellar: :any_skip_relocation, sonoma:        "61b6544e5fb8384dae2df5c982e121f63a33fea9654da56d0d21e796d6c8cf7c"
    sha256 cellar: :any,                 arm64_linux:   "619b5570ff3ef2f3f20f1ccbe40d9af6ef9db4e4cbee38ba764f27ed1214e4c0"
    sha256 cellar: :any,                 x86_64_linux:  "e0e6cb49c01a9e92fd9d285941440c0a8a2bf489611a7cded0cc00fd6252e5a1"
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
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
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