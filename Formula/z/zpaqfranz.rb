class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://ghproxy.com/https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/58.11.tar.gz"
  sha256 "960e669074ea7088637ea4ebd92e2de5ce09379774cf776c2c7dc89369717a55"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :url
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "332122ecb7d673e461a771186d7b1a815944612c70cdce431b8880616573ed38"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f48a550b9659ecb98954019c9a9667337e18205a0c6e1f814e1abd8ff40f4fe6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1421f172a89f2833d88403fbbf931d13ff67c2376ed6c017551d0a5949e83ae4"
    sha256 cellar: :any_skip_relocation, sonoma:         "5541c867a8170c8b0b7adcaa9516df5a7846c2162b94e77d1cc18efaf60613d9"
    sha256 cellar: :any_skip_relocation, ventura:        "189a03c88f0a5641aa2601972e21e6c6766576e516b6bdee2fd676ca359309e4"
    sha256 cellar: :any_skip_relocation, monterey:       "1813780e80e97b3b106850ad0c9cc6639ef0096569e7ac03de58791452e1cf30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4da1285e0bc3e0b00a466bf1d231f405aadbd572285fbca3f9b41792c8913c57"
  end

  def install
    bin.mkdir

    # JIT only works on Intel (might work on Linux aarch64, but not Apple Silicon)
    ENV.append_to_cflags "-DNOJIT" unless Hardware::CPU.intel?

    system "make", "install", "-f", "NONWINDOWS/Makefile", "BINDIR=#{bin}/#{name}"
    man1.install Utils::Gzip.compress("man/zpaqfranz.1")
  end

  test do
    system bin/"zpaqfranz", "autotest", "-to", testpath/"archive"
    system bin/"zpaqfranz", "extract", testpath/"archive/sha256.zpaq", "-to", testpath/"out/"
    testpath.glob("out/*").each do |path|
      assert_equal path.basename.to_s.downcase, Digest::SHA256.hexdigest(path.read)
    end
  end
end