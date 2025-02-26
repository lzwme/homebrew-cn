class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek peer-to-peer network"
  homepage "https:nicotine-plus.org"
  url "https:files.pythonhosted.orgpackages02a62797643ecf57f66c7d926dca073a249490bdcf21e7d9317d7bdcdcd95f88nicotine_plus-3.3.8.tar.gz"
  sha256 "c2e85a155088d9fab55be22597849df855767360276b9c5671155f9845de6207"
  license "GPL-3.0-or-later"
  head "https:github.comnicotine-plusnicotine-plus.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "477f72d5df21ca011ae3180eb0c07762d5cf64b737e670a8b2b0508b1135ce5b"
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