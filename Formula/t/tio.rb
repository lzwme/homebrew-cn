class Tio < Formula
  desc "Simple TTY terminal IO application"
  homepage "https:tio.github.io"
  url "https:github.comtiotioreleasesdownloadv3.1tio-3.1.tar.xz"
  sha256 "09a22f2c9b08bd45dcdf98ffed220e4b26fd07db30854d5439e3806dea9dfa7b"
  license "GPL-2.0-or-later"
  head "https:github.comtiotio.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sonoma:   "6a800b0dcb7156a11ee13edf7cceea95b26275f1f8d05042036fc3af0ac35745"
    sha256 cellar: :any, arm64_ventura:  "aa6188b64f086cd3b917e5e9f5518c70fe476a626da4dcc88b1126bfda6734cd"
    sha256 cellar: :any, arm64_monterey: "a6dbbe5a81e44cc685eff613551e4c929a5ebf5921d76f74c84e882304638947"
    sha256 cellar: :any, sonoma:         "25479ad7c1cce22f7210d4e6762d69b066372f164cb557a0cae76eae1a902486"
    sha256 cellar: :any, ventura:        "cf11490ff74695e32c853f07558f0fd8597c943373495ade51816c5387bcba41"
    sha256 cellar: :any, monterey:       "b7ce088222cb169c44ee9501f8475ca930c8375bd23aa7d02858c7a89aac72d5"
    sha256               x86_64_linux:   "35ad553eff6f73c4b7cc1793b8b0691d89dc3b388397839cc184d6101021c7a0"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "lua"

  def install
    system "meson", "setup", "build", "-Dbashcompletiondir=#{bash_completion}", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # Test that tio emits the correct error output when run with an argument that is not a tty.
    # Use `script` to run tio with its stdio attached to a PTY, otherwise it will complain about that instead.
    expected = "Error: Not a tty device"
    output = if OS.mac?
      shell_output("script -q devnull #{bin}tio devnull", 1).strip
    else
      shell_output("script -q devnull -e -c \"#{bin}tio devnull\"", 1).strip
    end
    assert_match expected, output
  end
end