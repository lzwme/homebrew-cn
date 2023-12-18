class Xdot < Formula
  include Language::Python::Virtualenv

  desc "Interactive viewer for graphs written in Graphviz's dot language"
  homepage "https:github.comjrfonsecaxdot.py"
  url "https:files.pythonhosted.orgpackages2d747f9af65f53fda367a82b5355bc8dd55d6cc0320bbc84b233749df3fd58f0xdot-1.3.tar.gz"
  sha256 "16dcaf7c063cc7fb26a5290a0d16606b03de178a6535e3d49dd16709b6420681"
  license "LGPL-3.0-or-later"
  head "https:github.comjrfonsecaxdot.py.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cfd20092807c67ab1a5c845230fd0a47194584b80bf0b61c352e416b9091abe0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c4e8ff2992ab0f8a0b956be46d414b689345937d86af00db7ba20edd84b7eb2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa92733a310e3bed98f618c95792efe6ea04869e4d220d099453583bf3685c23"
    sha256 cellar: :any_skip_relocation, sonoma:         "422bc2b224a565d1735efb399c6be9d06935fba43ba4d11b04ddf7f5255d9a5a"
    sha256 cellar: :any_skip_relocation, ventura:        "1f6dd36922ca31d7bb27384b7e1b46513ae79816932054e8f31c183288a33a0e"
    sha256 cellar: :any_skip_relocation, monterey:       "d5dc75804f2a40eaa82e9dee865ff10f195d401a998a34dc61e1bcffe71144dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18fe2be2d9aef5819cc52a291bd3bd2f495190089c383cee5e4e527b043d7687"
  end

  depends_on "adwaita-icon-theme"
  depends_on "graphviz"
  depends_on "gtk+3"
  depends_on "numpy"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.12"

  resource "graphviz" do
    url "https:files.pythonhosted.orgpackagesa590fb047ce95c1eadde6ae78b3fca6a598b4c307277d4f8175d12b18b8f7321graphviz-0.20.1.zip"
    sha256 "8c58f14adaa3b947daf26c19bc1e98c4e0702cdc31cf99153e6f06904d492bf8"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Disable test on Linux because it fails with this error:
    # Gtk couldn't be initialized. Use Gtk.init_check() if you want to handle this case.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin"xdot", "--help"
  end
end