class Pympress < Formula
  include Language::Python::Virtualenv

  desc "Simple and powerful dual-screen PDF reader designed for presentations"
  homepage "https://github.com/Cimbali/pympress/"
  url "https://files.pythonhosted.org/packages/08/3f/9fd254a40155c8f51b52b045f5df16a794d21d4c3dfeb8c5d379671e72f1/pympress-1.8.2.tar.gz"
  sha256 "d9587112ab08b1c97d8f9baccde2f666b4b6291bd22fcb376d27574301b2c179"
  license "GPL-2.0-or-later"
  head "https://github.com/Cimbali/pympress.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1eeccea821949ac7769026f48017e33d10d4d2a9733050f18e3abef8223c0b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2272b58efbb36e3f7673c7c2d8e35e92014a8c4b0c693ac3f93847bd5c538bb4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8fb791e60461fe3c16881d8fa43f4ba8b4b220472e9e8500ba208fc2b940673"
    sha256 cellar: :any_skip_relocation, ventura:        "56a8e468bac364046adaa3fe9787584d0fab7b1a7e7b09adb6a3cd4187a275b8"
    sha256 cellar: :any_skip_relocation, monterey:       "9eb46e615ad64fc0aa56875c0b64cd87122050144ebd851661803d2bde03bdc4"
    sha256 cellar: :any_skip_relocation, big_sur:        "88ec5a52c69b793ed6fab371180a09e9034929ead3f35a175fc1ae17be9fc2d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7f0ab90532660d2f98bc78b80e11d9fa8a77bf809a71cb36a957aa4a3114587"
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
    url "https://files.pythonhosted.org/packages/95/a6/d6ef450393dac5734c63c40a131f66808d2e6f59f6165ab38c98fbe4e6ec/watchdog-3.0.0.tar.gz"
    sha256 "4d98a320595da7a7c5a18fc48cb633c2e73cda78f93cac2ef42d42bf609a33f9"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/pympress"
  end

  test do
    # (pympress:48790): Gtk-WARNING **: 13:03:37.080: cannot open display
    ENV["PYMPRESS_HEADLESS_TEST"]="1" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"pympress", "--quit"

    # Check everything ran fine at least until reporting the version string in the log file
    # which means all dependencies got loaded OK. Do not check actual version numbers as it breaks --HEAD tests.
    log = if OS.linux?
      Pathname.new(ENV["XDG_CACHE_HOME"] || (testpath/".cache"))/"pympress.log"
    else
      testpath/"Library/Logs/pympress.log"
    end
    assert_predicate log, :exist?
    assert_match "INFO:pympress.app:Pympress:", log.read
  end
end