class Chawan < Formula
  desc "TUI web browser with CSS, inline image and JavaScript support"
  homepage "https://sr.ht/~bptato/chawan/"
  url "https://git.sr.ht/~bptato/chawan/archive/v0.2.0.tar.gz"
  sha256 "7bf23c2f41d777f951a189374cb8edf913a9bfb2102a1a0f274c587b8edb6a75"
  license "Unlicense"
  head "https://git.sr.ht/~bptato/chawan", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "947cea8a8995e723b23a1356a4124de83458d07e85ec0aa8e53429a8860c0cb7"
    sha256 cellar: :any,                 arm64_sonoma:  "dc1da334eaf9da2251992bd143b4867b7675712226c369bfecfba500963f5732"
    sha256 cellar: :any,                 arm64_ventura: "819d155a57265cad1ffe38e7b15e0f42dddf09ef98a3893f80c95ea8bb73fd3b"
    sha256 cellar: :any,                 sonoma:        "a6a6e1e9e86de56ce0f189cae9244fca36f7cdd09431a1eb3b0b3cb47cb1a08f"
    sha256 cellar: :any,                 ventura:       "588dcc354363e1e7ce54d1ec7171bbadacfba7f08822e15d623fda1dc82a0d64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9dcab93cc7449e5970674f10d9de472e2a97ef23476738cef37ff47b66be952a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7e131a7b8240c9a62f98092b27c4a14d51d60122dc3c9d116a76f4bda9930d9"
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