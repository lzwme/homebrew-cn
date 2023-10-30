class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px / ptop)"
  homepage "https://github.com/walles/px"
  url "https://github.com/walles/px.git",
      tag:      "3.4.1",
      revision: "22594952ce4d41da4ff79619aa5761ea47f42964"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3b10b677ab946c9b9287513b9838ab32cf03442fd74f8b8e32e8dba8cd613fb6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21cca13c132c4f6763178c6cad203761ec19f5fbea1db25ff7f27dc9f2f4eb2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96c5c53b3e8115ab26511ea6a6d470d10b2f0a23bb2d09d0c2de939adb86b29a"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b4f862a91abf9cc23a242e5b59f8c19408c2865b7684cc577d20dae240f0b24"
    sha256 cellar: :any_skip_relocation, ventura:        "6aebb1b0b43dd89df09d85b40438d4c95d080165505ac3565ec5fca59dcb99b0"
    sha256 cellar: :any_skip_relocation, monterey:       "c368fbbf104c15957e64d4b2b141f5e82b7c173ee64d38330e8739fcf1381c84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff852cad694bf7b1628dbe68cc0243d4de9975a8910d27598ca280af2a45f35f"
  end

  depends_on "python@3.12"
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