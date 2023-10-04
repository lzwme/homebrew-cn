class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px / ptop)"
  homepage "https://github.com/walles/px"
  url "https://github.com/walles/px.git",
      tag:      "3.4.0",
      revision: "18dd82c9cbfb85b50f835e120b10d71a20c35de3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee16b97e2dc20cc75df898e38089c94e6ca2c9ebd8e3f32436fd1cf7392a12a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01aea88c5bccb6cddb9d6d7f76bf38c143bafd761cb9ef9311f9b8cac19e7436"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c62ee044e4349b81826adeb6202ede26e85aa380bef6156c53fb90a152b5cbac"
    sha256 cellar: :any_skip_relocation, sonoma:         "3075b607f724b96c9b6ba07ac68e6c6420660ac4b1b126c458e30c5b168dd6da"
    sha256 cellar: :any_skip_relocation, ventura:        "ea4b7f9849885b59f76ab4feb849ffb0e61fe59b9835e5f6ea4cb1085f7e852c"
    sha256 cellar: :any_skip_relocation, monterey:       "c63b674ffe129bcd68e8752c0355e89cd884fe978aa65543e265e91823518f68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d33e60156b1a95dd9932f011c56f85d1377061cffcab86511c3bebd6e4dc9899"
  end

  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "lsof"

  # For updates: https://pypi.org/project/python-dateutil/#files
  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  def install
    virtualenv_install_with_resources
    man1.install Dir["doc/*.1"]
  end

  test do
    split_first_line = pipe_output("#{bin}/px --no-pager").lines.first.split
    assert_equal %w[PID COMMAND USERNAME CPU CPUTIME RAM COMMANDLINE], split_first_line
  end
end