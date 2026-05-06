class Pay < Formula
  desc "HTTP client that automatically handles 402 Payment Required"
  homepage "https://github.com/solana-foundation/pay"
  url "https://ghfast.top/https://github.com/solana-foundation/pay/archive/refs/tags/pay-v0.15.0.tar.gz"
  sha256 "5dfa3599c8f69aec2798eb0afd6d57cb33fbb175850c50a9534093fd45c7570e"
  license "MIT"
  head "https://github.com/solana-foundation/pay.git", branch: "main"

  livecheck do
    url :stable
    regex(/^pay[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a50e8d10b835917a8cea6b59fc6413a989633b122698861f008b45dc09f14ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e06bf9bfcaa411920f7ed988e1cce8494b03bf2221ebbdbd1031ba671871804"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e187d79871b9ed0cc3ba8914bb3702592877192f2889266297b863a2bc27c5fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "da0a1def936036738f0846d009991fdbbdda786b16212f015045d50a9af6298f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7829f52c6d47b97bf107df84d5d7c70384c42564a81fb2a72b75b8062a31cba3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "493cc2b330461fe91e702cbdeb0cb006eedabfa4507ed36eb0edc36e8a119fbc"
  end

  depends_on "just" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  uses_from_macos "python"

  def install
    system "just", "install", "pay", *std_cargo_args(path: "rust/crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pay --version")

    expected = "No pay account configured"
    assert_match expected, shell_output("#{bin}/pay --no-dna fetch https://httpbin.org/status/402 2>&1", 1)
  end
end