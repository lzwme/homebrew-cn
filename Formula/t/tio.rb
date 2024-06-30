class Tio < Formula
  desc "Simple TTY terminal IO application"
  homepage "https:tio.github.io"
  url "https:github.comtiotioreleasesdownloadv3.5tio-3.5.tar.xz"
  sha256 "efd3e9a406f827ac22d4157e345079dde15ee5a948b24156561d6c97a54e6ec0"
  license "GPL-2.0-or-later"
  head "https:github.comtiotio.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "a7a1ec7ee2d60c3736e2f5dd9c6539b798529748cd286297a04fddbeab342030"
    sha256 cellar: :any, arm64_ventura:  "e8c13da32cef114a0560a20bb3af9a64cf0f0d045b79764e8df04540177253c8"
    sha256 cellar: :any, arm64_monterey: "99e1ad3a4a8d97d35136a1a2634b538c69e4595c8ffde88e75e7de5f0601b3e4"
    sha256 cellar: :any, sonoma:         "65e8723cec535c6e206efe10d5202e798049793f6660605977f3f88a089147ca"
    sha256 cellar: :any, ventura:        "5b1a0e3f0595db6b2311a8b40c2dac865664caab7db1bc287ce64b3921310d80"
    sha256 cellar: :any, monterey:       "9af5eaf690b86ab92a7cfcb7305e71051229fb2c98d0145d6cc76ff0e25eb657"
    sha256               x86_64_linux:   "d54f723ad37a40227f3fae8971408293bcb1d1e45e325dc3d628414c3b435ffe"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
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