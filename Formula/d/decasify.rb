class Decasify < Formula
  desc "Utility for casting strings to title-case according to locale-aware style guides"
  homepage "https://github.com/alerque/decasify"
  url "https://ghfast.top/https://github.com/alerque/decasify/releases/download/v0.11.3/decasify-0.11.3.tar.zst"
  sha256 "2404c9f1c163b4290aeb93694d3ad49181c0a389c3aea7ed6abab22489d14e93"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78189462d8b0460d58e55c79f4cf8774705687768eedf7aa5125cf39dccd727c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "466999bc1594c6d1e7ddadba40471c008ec035b3106c3de1385cb461abf0db82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87c10fe5068ea9d3fe6a5b13f9148c36686e94c0cb51819933addfd9dc78f175"
    sha256 cellar: :any_skip_relocation, sonoma:        "5139aa9b7383fdec1c58f0855eecc9c2fbb3c33e7010cd7f54ec59062b90edf3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a472599e9f00b8af4cd0680e41d3dfef2375e323c6e4301fd3346e2e7d37d87d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec6443b0044e39e2fc66c5629ebb370b57466592af075636eb57f566f5c4a1f9"
  end

  head do
    url "https://github.com/alerque/decasify.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "jq" => :build, since: :sequoia
  uses_from_macos "zlib"

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "decasify v#{version}", shell_output("#{bin}/decasify --version")
    assert_match "Ben ve İvan", shell_output("#{bin}/decasify -l tr -c title 'ben VE ivan'")
  end
end