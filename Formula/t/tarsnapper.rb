class Tarsnapper < Formula
  include Language::Python::Virtualenv

  desc "Tarsnap wrapper which expires backups using a gfs-scheme"
  homepage "https://github.com/miracle2k/tarsnapper"
  url "https://files.pythonhosted.org/packages/4e/c5/0a08950e5faba96e211715571c68ef64ee37b399ef4f0c4ab55e66c3c4fe/tarsnapper-0.5.0.tar.gz"
  sha256 "b129b0fba3a24b2ce80c8a2ecd4375e36b6c7428b400e7b7ab9ea68ec9bb23ec"
  license "BSD-2-Clause"
  revision 1

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "026355056a10fa2326548ecf07457fed9c9c13000b24d06e5509915e4709a4bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e9a0dd7678651dc5e6b74fb69e0753a54de1dac10c3014d69290331ede9c2ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a75e1ec70d9ac8e3ad98ec0ce4dcb1fd17bb8c5a981f2b775f4dad25ad8bf354"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d3bb97776d3583bbe263d2cfa25e663b0bfdc4a64eb9cb0e0e44054a244be07"
    sha256 cellar: :any_skip_relocation, ventura:        "a73eee3b708408e1df3aecc4e9e3cf9b60aae64dc492ca36a83afc44321b314b"
    sha256 cellar: :any_skip_relocation, monterey:       "49ef96c3a76e577526b85f1ec95b43ec51d40e99ca0f1febf787aecd7d558d63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "281f63f9ab7c817ef7f706edd6e448b3fb6deb2df0ae47eff226de67e5091256"
  end

  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"
  depends_on "tarsnap"

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/e5/9b/ff402e0e930e70467a7178abb7c128709a30dfb22d8777c043e501bc1b10/pexpect-4.8.0.tar.gz"
    sha256 "fc65a43959d153d0114afe13997d439c22823a27cefceb5ff35c2178c6784c0c"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "usage: tarsnapper", shell_output("#{bin}/tarsnapper --help")
  end
end