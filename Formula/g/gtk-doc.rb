class GtkDoc < Formula
  desc "GTK+ documentation tool"
  homepage "https://gitlab.gnome.org/GNOME/gtk-doc"
  url "https://download.gnome.org/sources/gtk-doc/1.33/gtk-doc-1.33.2.tar.xz"
  sha256 "cc1b709a20eb030a278a1f9842a362e00402b7f834ae1df4c1998a723152bf43"
  license "GPL-2.0-or-later"
  revision 1

  # We use a common regex because gtk-doc doesn't use GNOME's
  # "even-numbered minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/gtk-doc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02b7c96eec8b4826b9503e24034aa4681af407e7a274fed1515cd7bbe648de95"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02b7c96eec8b4826b9503e24034aa4681af407e7a274fed1515cd7bbe648de95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02b7c96eec8b4826b9503e24034aa4681af407e7a274fed1515cd7bbe648de95"
    sha256 cellar: :any_skip_relocation, sonoma:         "02b7c96eec8b4826b9503e24034aa4681af407e7a274fed1515cd7bbe648de95"
    sha256 cellar: :any_skip_relocation, ventura:        "02b7c96eec8b4826b9503e24034aa4681af407e7a274fed1515cd7bbe648de95"
    sha256 cellar: :any_skip_relocation, monterey:       "02b7c96eec8b4826b9503e24034aa4681af407e7a274fed1515cd7bbe648de95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15e6cd564005258dc7e144ead0eed77fe8564bf00ec7d628919534640fb6a50b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "docbook"
  depends_on "docbook-xsl"
  depends_on "pygments"
  depends_on "python-anytree"
  depends_on "python-lxml"
  depends_on "python@3.12"

  def install
    # To avoid recording pkg-config shims path
    ENV.prepend_path "PATH", Formula["pkg-config"].bin

    system "meson", "setup", "build", *std_meson_args, "-Dtests=false", "-Dyelp_manual=false"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"gtkdoc-scan", "--module=test"
    system bin/"gtkdoc-mkdb", "--module=test"
  end
end