class Chawan < Formula
  desc "TUI web browser with CSS, inline image and JavaScript support"
  homepage "https://sr.ht/~bptato/chawan/"
  url "https://git.sr.ht/~bptato/chawan/archive/v0.4.0.tar.gz"
  sha256 "6e0c8e342bdb06cd6830252aa6e4f57b6b44c479e7c07dde0db1ccbad4af2034"
  license "Unlicense"
  head "https://git.sr.ht/~bptato/chawan", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "564019706565b2bca0bcaeffba3ed98f2167eaf2c079b438cee05a91187dcf80"
    sha256 cellar: :any,                 arm64_sequoia: "589bb8abec15e9d05f9061b13a25a4f1628944105fd222504d3a8520f94f4ec7"
    sha256 cellar: :any,                 arm64_sonoma:  "c3e4e3c3e7b3a2eb2701d694712453429c707c4eae6d88f478ce02d798a69b7a"
    sha256 cellar: :any,                 sonoma:        "f5a53d15dec9429facb9758e02405ff972f2739a4275de62cdcb77f5120e5ff2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b57fc1887cb6ef4da854cc0cd6c73eac8d2a5c9a287b1c9ce7331ab0c63b1c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84387de14abf7f5964e59f809872d936b1b80720b6a4f1e7d4cc84fbc283ac2e"
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