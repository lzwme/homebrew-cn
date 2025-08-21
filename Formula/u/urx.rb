class Urx < Formula
  desc "Extracts URLs from OSINT Archives for Security Insights"
  homepage "https://github.com/hahwul/urx"
  url "https://ghfast.top/https://github.com/hahwul/urx/archive/refs/tags/0.7.0.tar.gz"
  sha256 "6b8e33da49b1520763eaea24d43cd399b833f832a160af2c7b0cc869804d1dcd"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6de82d54d095f30f310a7e2f905e5c7d01259d7f6c72637f0eb54790f2063cf3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fe7cc623e2cdea2f23070bc89b40503ddf3caee699db8688f4f969d978a7c90"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eb129b6e6571023b90d47a481d1de81d7a2992b1b27a0b17a4ff260d1fb63a8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "cea7109203e59bd23079f293f525896a2819e07c26403f2d31f29f6f667ed045"
    sha256 cellar: :any_skip_relocation, ventura:       "8819036aba9d3f89ad17a57342b3bdf8fe7dc98bde3ab18904c0817ae25c03e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18d92d4f4e42bfce5b3a9bff59fb0e86af3939886518a4d06c47cc31b2cb2edb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "779313f214d5c6e17b3075eb3033df0e25716417d4987f183918f90f25374cdb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  on_linux do
    depends_on "openssl@3"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "urx #{version}", shell_output("#{bin}/urx --version")
    assert_match "https://brew.sh/", shell_output("#{bin}/urx brew.sh --providers=cc --include-sitemap")
  end
end