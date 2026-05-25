class Chawan < Formula
  desc "TUI web browser with CSS, inline image and JavaScript support"
  homepage "https://sr.ht/~bptato/chawan/"
  url "https://git.sr.ht/~bptato/chawan/archive/v0.4.1.tar.gz"
  sha256 "cf09e0205f8db28cc916c44f2ac1def6392efc9d66f3c88dc9aae413079ebb2c"
  license "Unlicense"
  head "https://git.sr.ht/~bptato/chawan", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c0a88e1de7715b8853b88cf6506169f9b652f62ab629568b46a1bf32a182f456"
    sha256 cellar: :any,                 arm64_sequoia: "181a12f83d9f199d884b2aff04bc5b3bb9e629b8f84d0ec4e3b0e7e616c675e7"
    sha256 cellar: :any,                 arm64_sonoma:  "f3a6cf85789177f2f5c25a995af7131102ded70f8dcdffe5256f0c143506eb7a"
    sha256 cellar: :any,                 sonoma:        "50b6c5c9f3933dd6dc8415f9d1b1df4ed5ab4a4c5ea2ec413f3901fb8da9c81a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10a232fb080b287ec20824e22e87f3e4705067b4b5b65521dd274e6893e5a490"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27ba946b54fba31acf655b4b2b343b2fae1faab3cc384954c7fb6e041c759cb9"
  end

  depends_on "nim" => :build
  depends_on "pkgconf" => :build

  depends_on "brotli"
  depends_on "libssh2"
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cha --version")
    assert_match "Example Domain", shell_output("#{bin}/cha --dump https://example.com")
  end
end