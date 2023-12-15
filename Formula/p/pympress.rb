class Pympress < Formula
  include Language::Python::Virtualenv

  desc "Simple and powerful dual-screen PDF reader designed for presentations"
  homepage "https://github.com/Cimbali/pympress/"
  url "https://files.pythonhosted.org/packages/17/65/ffd6b30dae047fab0d4b1bef14940f194f555e9b7b6fe1520a650233e6ca/pympress-1.8.4.tar.gz"
  sha256 "ddc9c21c6a0a517d204f3231d6484cf9bafac7dfa0f565e1dbc48b866f7d78de"
  license "GPL-2.0-or-later"
  head "https://github.com/Cimbali/pympress.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6b2b7872768bcc7b5752eda38ecbcffa95996c46f2e2ae76310b44e9a0a37a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f68ccb6aa6943f2d02bdb89fd9e6a3eeb69a96ec2f0ff42c38595145085608d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47679c46dbcf03fca943560d5d5d5a5c20fd98e0e33dec7fc8387ca01857cf9a"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5e56d129c2ed50f008c2f224b9fbaf9d3c938d17309b3e7816cfc248d3f31b1"
    sha256 cellar: :any_skip_relocation, ventura:        "3560a08e36b9fe2aabfd6b104c09c6e15f5bf0b7c2f78d61ae46453e0be764f8"
    sha256 cellar: :any_skip_relocation, monterey:       "8de9bf208783574c1052aea7b598e14b9dd747f1487f17e3cd797d6177c3b48b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfcff93ba45eb9eaafb4d20e4e81659e1c48faee7b3053c4f035fe6a7b88c353"
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