class Pympress < Formula
  include Language::Python::Virtualenv

  desc "Simple and powerful dual-screen PDF reader designed for presentations"
  homepage "https://github.com/Cimbali/pympress/"
  url "https://files.pythonhosted.org/packages/f6/a0/93d92200dd3febe3c83fbf491a353aed2bb8199cfc22f3b684ea77cdbecf/pympress-1.7.2.tar.gz"
  sha256 "2c5533ac61ebf23994aa821c2a8902d203435665b51146658fd788f860f272f2"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/Cimbali/pympress.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32aa8239aa89a47af3fcc7144f8a6e9c5c2bb8e3a6b59a33708a253c9ef9d98e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf41626acb9a3d0a00e8582de2232a3ce1be4de8e4677b661b88a5e53ac46be6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a9e2826ff9bd757ed3bf3904689dab13746d405717731652698a5ee8360cd08"
    sha256 cellar: :any_skip_relocation, ventura:        "65e9fdfa2883fc42d7ee18a375eae49afc054030b81b6b16a46e66fc40aaf67c"
    sha256 cellar: :any_skip_relocation, monterey:       "43eb945098ddf83c730e1008363cd4261a2ab4693a424c3af0a0bd2c3ad53243"
    sha256 cellar: :any_skip_relocation, big_sur:        "7bff0ca7febe83bdd4b61b274b8f77867835d758010c081b4664fb41a6731dbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db78264033f402c9b0553461e06d2fe7cb0a10c0d3fbbafd20705e5b420a14cc"
  end

  depends_on "gobject-introspection"
  depends_on "gst-plugins-bad"
  depends_on "gst-plugins-base"
  depends_on "gst-plugins-good"
  depends_on "gst-plugins-ugly"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "libyaml"
  depends_on "poppler"
  depends_on "pygobject3"
  depends_on "python@3.11"

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/b3/d2/a04951838e0b0cea20aff5214109144e6869101818e7f90bf3b68ea2facf/watchdog-2.1.7.tar.gz"
    sha256 "3fd47815353be9c44eebc94cc28fe26b2b0c5bd889dafc4a5a7cbdf924143480"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/pympress"
  end

  test do
    # (pympress:48790): Gtk-WARNING **: 13:03:37.080: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"pympress", "--quit"
  end
end