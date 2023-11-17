class Mat2 < Formula
  desc "Metadata anonymization toolkit"
  homepage "https://0xacab.org/jvoisin/mat2"
  url "https://files.pythonhosted.org/packages/d5/e4/f02d057fe6cf32b68e402c5f86276244105da40161e84ef785b2ae0bf809/mat2-0.13.4.tar.gz"
  sha256 "744aeee924c9898a397fe930593b803c540389bf39cd24553b99a89acc2f5901"
  license "LGPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d029eaa7463e795b24ca8fbbc958aa296acd2e0c229f0f272d7bfc3c689173d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c3f81cda2ad80e7fff2ad6057910983821953d35f3a00e55ff166444803219f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f6f8b108b3c77a2bb9a17a6f4f179e465a307a5ecb827456214ce92a2394e1a"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c163a7c500b2caa50a6b4e0dd1f9ab57eaea59acf5a349cafdf575d72b0aec5"
    sha256 cellar: :any_skip_relocation, ventura:        "6edf65d88a4493625f0b5893778b76fea9bb8e0b502e7ae11684fca21a37f850"
    sha256 cellar: :any_skip_relocation, monterey:       "78069965b1edffc23c317d6fd38884c641e51ca6db02aa47a6180b8562b63c8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d024a4da451994028b3f3611cfaf1b2202a5fd58473903920ffce173b4031c2"
  end

  depends_on "exiftool"
  depends_on "ffmpeg"
  depends_on "gdk-pixbuf"
  depends_on "librsvg"
  depends_on "poppler"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python-mutagen"
  depends_on "python@3.12"

  # patch man1 file layout, remove in next release
  # https://0xacab.org/jvoisin/mat2/-/merge_requests/111
  patch do
    url "https://0xacab.org/jvoisin/mat2/-/commit/406924bb6164384fe0a8a8f3dc8dfe7d15577cfc.diff"
    sha256 "4c1c57ca8fe1eabea41d66f3ef9bd4eb2bac8ac181fceeefece4b92b5be9658d"
  end

  def python3
    which("python3.12")
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    system bin/"mat2", "-l"
  end
end