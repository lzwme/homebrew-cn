class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://ghproxy.com/https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/58.2.tar.gz"
  sha256 "7b66c94bb22ff03205777c0be0e70747a0f7ef8eff9b99e2b1ac384aa495977f"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :url
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1428ecc0db3b3a71f656211d2c1910e1fae658481a3662abbd272a7c83ec10fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c49c248cbb6aa9be78fec92898aa93c5d8b282397890330fcfa7fc28795ad208"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae4a99f06ce303403355b0b7edd12021894350317db7999ecd4663a572b50059"
    sha256 cellar: :any_skip_relocation, ventura:        "9a76dd6b1ebc7d84ce13cd6682ae16f6c97f7d5462eea276e7f69f14299ef862"
    sha256 cellar: :any_skip_relocation, monterey:       "8c4e349d56fe1c48a992b6ff32d5385071cb226c2e37b3c9060b0ebd7b73fe9e"
    sha256 cellar: :any_skip_relocation, big_sur:        "be658e93e4a00fb0be8628a28db99ed8c0e8119a6e7210408773da4750be3606"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4636bd3edb7264beb167bf70364a5a9d05207038b0436eaa786c50eb6376bbb"
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