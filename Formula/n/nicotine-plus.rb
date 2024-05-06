class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek peer-to-peer network"
  homepage "https:nicotine-plus.org"
  url "https:files.pythonhosted.orgpackages0d907e808ba3a5d9bcff4319c50ed7ac233853d8f5cd90518caf0c5305f1d3bcnicotine_plus-3.3.3.tar.gz"
  sha256 "699a9a4904cca213235ed3d6aea55ebebc3d78ba766648c7b5042bf8d2c462e7"
  license "GPL-3.0-or-later"
  head "https:github.comnicotine-plusnicotine-plus.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66123fc4312d6f6e7c91892527ddc0c955324aff4f321f6ebbab436af81407a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66123fc4312d6f6e7c91892527ddc0c955324aff4f321f6ebbab436af81407a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66123fc4312d6f6e7c91892527ddc0c955324aff4f321f6ebbab436af81407a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "66123fc4312d6f6e7c91892527ddc0c955324aff4f321f6ebbab436af81407a6"
    sha256 cellar: :any_skip_relocation, ventura:        "66123fc4312d6f6e7c91892527ddc0c955324aff4f321f6ebbab436af81407a6"
    sha256 cellar: :any_skip_relocation, monterey:       "66123fc4312d6f6e7c91892527ddc0c955324aff4f321f6ebbab436af81407a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58e9496311f34a6aef3fd0c127a9b8aff7ea59ef0d4f1511e3a00bb999ed8913"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python-gdbm@3.12"
  depends_on "python@3.12"

  on_linux do
    depends_on "gettext" => :build # for `msgfmt`
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # nicotine is a GUI app
    assert_match version.to_s, shell_output("#{bin}nicotine --version")
  end
end