class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/9f/b8/0fe3359920b0a4e7008e0e93ff383003763e3eee3eb31a07c52868722960/pyinstaller-6.18.0.tar.gz"
  sha256 "cdc507542783511cad4856fce582fdc37e9f29665ca596889c663c83ec8c6ec9"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "799d64346642d46b6fc2cb87a59c5e18c96b666f5e3803e558feec614f15230f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39f0dad7650a64925225bd7f81a04ffc3e4d41df56730100d280c233fac6ac6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38c05c20d08410513724a00a815566c8d16b51615d3fd3d687a718cdaafd1e2e"
    sha256 cellar: :any_skip_relocation, tahoe:         "c03d80f6731ebca75994f5f99678ced88f92717e336010fd3ce05db0f6da8d26"
    sha256 cellar: :any_skip_relocation, sequoia:       "83d25478681c25cee9971031579f30c0b26d197e7339b00155f93088ed4486e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "078f3a5c29d7ae56e571b28cdc8e8e1b29b07b344fd1596136a6a8a662fe6dcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95d3d2de57dbc6ea2f126fba0eb9cd9270225e6c63d5249e4ab6e9a6d3da44dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b056044ca37441fadbc7635a8d57c7dbc92a3bc6d9ee9c5ac6e7a2bc44bb013f"
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
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/45/2f/2c68b6722d233dae3e5243751aafc932940b836919cfaca22dd0c60d417c/pyinstaller_hooks_contrib-2025.11.tar.gz"
    sha256 "dfe18632e06655fa88d218e0d768fd753e1886465c12a6d4bce04f1aaeec917d"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
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