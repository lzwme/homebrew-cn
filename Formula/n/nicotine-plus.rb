class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek peer-to-peer network"
  homepage "https:nicotine-plus.org"
  url "https:files.pythonhosted.orgpackages5ad3a489967ab67165a6893f23e03c5134cf1b9cd35fd826c0a7c9ea3c743cb9nicotine_plus-3.3.6.tar.gz"
  sha256 "6a0b39c5ff4fb4768689516a3a2cfe3aafdc568b5237f19553c51b1de712ee66"
  license "GPL-3.0-or-later"
  head "https:github.comnicotine-plusnicotine-plus.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "1efbc77356619bdb2f9ab67519031f51fa3e19eb262f890b805ca5df9aaf66f6"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk4"
  depends_on "libadwaita"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.13"

  on_linux do
    depends_on "gettext" => :build # for `msgfmt`
  end

  conflicts_with "httm", because: "both install `nicotine` binaries"

  def install
    virtualenv_install_with_resources
  end

  test do
    # nicotine is a GUI app
    assert_match version.to_s, shell_output("#{bin}nicotine --version")
  end
end