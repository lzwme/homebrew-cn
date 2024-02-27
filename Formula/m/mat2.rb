class Mat2 < Formula
  include Language::Python::Virtualenv

  desc "Metadata anonymization toolkit"
  homepage "https://0xacab.org/jvoisin/mat2"
  url "https://files.pythonhosted.org/packages/d5/e4/f02d057fe6cf32b68e402c5f86276244105da40161e84ef785b2ae0bf809/mat2-0.13.4.tar.gz"
  sha256 "744aeee924c9898a397fe930593b803c540389bf39cd24553b99a89acc2f5901"
  license "LGPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f3e360e4c603f6ed59196ec87eb03275d94c27be4bb6b1a4eb52a29b01475873"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa27b885eab427ed223e721cb2417a7a4e9b20d71611f7120a2f92bf9e19eca1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b34c0d2c0bb8d9d03f5b93567833d2af18f355da378cd96c1847fa2b53fbaa4"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7023c75aa32391edeb2b3e5549b87f79380a4c219765cc6626ee08c5e138b9e"
    sha256 cellar: :any_skip_relocation, ventura:        "c6987d4030e5b3894a7f1b5c4d4299e7e0422499b3fb498cd4c35be56d3a2c2e"
    sha256 cellar: :any_skip_relocation, monterey:       "bfe8a66952bba7ecadd2a28e826094a095bbe6df6cfd094245a33e58507da3ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ac3d34df70eb86cd3145b47d8886c0bebf8b28cfb8e6897110c320090a6e359"
  end

  depends_on "exiftool"
  depends_on "ffmpeg"
  depends_on "gdk-pixbuf"
  depends_on "librsvg"
  depends_on "poppler"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.12"

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/81/e6/64bc71b74eef4b68e61eb921dcf72dabd9e4ec4af1e11891bbd312ccbb77/mutagen-1.47.0.tar.gz"
    sha256 "719fadef0a978c31b4cf3c956261b3c58b6948b32023078a2117b1de09f0fc99"
  end

  # patch man1 file layout, remove in next release
  # https://0xacab.org/jvoisin/mat2/-/merge_requests/111
  patch do
    url "https://0xacab.org/jvoisin/mat2/-/commit/406924bb6164384fe0a8a8f3dc8dfe7d15577cfc.diff"
    sha256 "4c1c57ca8fe1eabea41d66f3ef9bd4eb2bac8ac181fceeefece4b92b5be9658d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"mat2", "-l"
  end
end