class GtkDoc < Formula
  include Language::Python::Virtualenv

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
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b4e1506fd994f382eb7ee00efee0745d75e8874784a90ebc393c23b430f7cfdb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1041ba8b732f965dc41eec98ee229e376f967527bcddf52538a3088eabf92db7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8faba080b682669a47015ab5b6606c6528210fad30e60cd22949f23de6cc21f"
    sha256 cellar: :any_skip_relocation, sonoma:         "ceb949f591965436723ecdaecbcce8279a8a878d9a7928d14a785c93a1d637ba"
    sha256 cellar: :any_skip_relocation, ventura:        "ca5b1b876cb87c764efd6d60ff6cc654fabdf0742307a22e223cb89e3fe13761"
    sha256 cellar: :any_skip_relocation, monterey:       "ae8a5b119ff95163e74fa4b930fbff6ff2446749d09209c0b7d1cf17b38d5971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83bf5530fd27c2f92f22ec0c710af8a47cd56ad559d6b3e4f32141f2323aed2e"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "docbook"
  depends_on "docbook-xsl"
  depends_on "pygments"
  depends_on "python-lxml"
  depends_on "python@3.12"
  depends_on "six" # for anytree

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/d8/45/de59861abc8cb66e9e95c02b214be4d52900aa92ce34241a957dcf1d569d/anytree-2.8.0.tar.gz"
    sha256 "3f0f93f355a91bc3e6245319bf4c1d50e3416cc7a35cc1133c1ff38306bbccab"
  end

  def install
    # To avoid recording pkg-config shims path
    ENV.prepend_path "PATH", Formula["pkg-config"].bin

    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resources
    ENV.prepend_path "PATH", libexec/"bin"

    system "meson", "setup", "build", *std_meson_args, "-Dtests=false", "-Dyelp_manual=false"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"gtkdoc-scan", "--module=test"
    system bin/"gtkdoc-mkdb", "--module=test"
  end
end