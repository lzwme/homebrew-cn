class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek peer-to-peer network"
  homepage "https://nicotine-plus.org"
  url "https://files.pythonhosted.org/packages/33/42/09d44ca8a6ee8eb9982e6e289bcc4523cbd8f2290decc3a07655c1a22bfd/nicotine-plus-3.2.8.tar.gz"
  sha256 "48e1bcda9483f3d2228f8c4ff6fe68f1b61898c354d54b1358726997b926b283"
  license "GPL-3.0-or-later"
  head "https://github.com/nicotine-plus/nicotine-plus.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f06d10dfef1cc041377adce921963991f93b115698d8ebec6370dc3a0f626ba6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d85bb9eef4a776c422a6e74fecf0e88127ab8633cc50a0c35a12d7a7fbc78887"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6bc35d904d3effa13eee880448f2a3bd28639fdd01643275ddb296790d4b6c6a"
    sha256 cellar: :any_skip_relocation, ventura:        "242b064428cdfeb1dbb0da56d8193c2c6dcbcc5954126c09b424bc131649ef6f"
    sha256 cellar: :any_skip_relocation, monterey:       "11f4c5b33d3705eb70f4fe3e069e40d4565b1d2439262d857f873d8e6e965023"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee84b4498d8aac59d3947af21288403c24ca040acd05c20a8e6c43b113979faf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20e7e727a531f9acdcd39d2712fb9e62cc35329fcd66a58761d460d8632832bc"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.11"

  on_linux do
    depends_on "gettext" => :build # for `msgfmt`
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nicotine -v")
    pid = fork do
      exec bin/"nicotine", "-s"
    end
    sleep 3
    Process.kill("TERM", pid)
  end
end