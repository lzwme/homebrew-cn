class Pympress < Formula
  include Language::Python::Virtualenv

  desc "Simple and powerful dual-screen PDF reader designed for presentations"
  homepage "https://github.com/Cimbali/pympress/"
  url "https://files.pythonhosted.org/packages/17/65/ffd6b30dae047fab0d4b1bef14940f194f555e9b7b6fe1520a650233e6ca/pympress-1.8.4.tar.gz"
  sha256 "ddc9c21c6a0a517d204f3231d6484cf9bafac7dfa0f565e1dbc48b866f7d78de"
  license "GPL-2.0-or-later"
  head "https://github.com/Cimbali/pympress.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c4ddd3f1b0c73133abe92076ece05865c46b29b0f21fe043983610d992a67bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24177f278b28c9b1504df98a9ba183b91f3436b9d1b77319afa9f657fd8cb1ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d5a8bd58fc2b21fbd744a22220884d9ad014cce751c29e7252f10ca9970ba22"
    sha256 cellar: :any_skip_relocation, sonoma:         "55833a12c097b1a74a9d852522c3071c7a6943b5f52b67dfb3160828117841a5"
    sha256 cellar: :any_skip_relocation, ventura:        "de8cd17331ac3b641ab6a2614b310fcabea5e798f6a50a764fb0178cdce6412a"
    sha256 cellar: :any_skip_relocation, monterey:       "4975114e3ee11877c08b8b3a92c98025b63a5d6cfb1f210d616b7d2276692ccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3be0b1e750d5130c37079276e59505427b21e2d894300ef378159156169a1c5d"
  end

  depends_on "gobject-introspection"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "libyaml"
  depends_on "poppler"
  depends_on "pygobject3"
  depends_on "python@3.12"

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/95/a6/d6ef450393dac5734c63c40a131f66808d2e6f59f6165ab38c98fbe4e6ec/watchdog-3.0.0.tar.gz"
    sha256 "4d98a320595da7a7c5a18fc48cb633c2e73cda78f93cac2ef42d42bf609a33f9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # (pympress:48790): Gtk-WARNING **: 13:03:37.080: cannot open display
    ENV["PYMPRESS_HEADLESS_TEST"]="1" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath/"Library/Preferences").mkpath

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