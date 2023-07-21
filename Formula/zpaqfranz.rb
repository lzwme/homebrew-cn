class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://ghproxy.com/https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/58.6.tar.gz"
  sha256 "a587406f2aca92215781b223e5211696cf240f913ae2c279f3dfa120ed22fe87"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :url
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b8a71d41330085f749aed3f558f63e7d0321818a9ffbb1ae9b83336480fc23e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b41879f18872af258ae9554ec142c549687bc562923359a05e8d9de9f406880"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5537b20cadff2394bc4447be699acee362e9c6f8b1f634a43d7e2eb1bb647eb8"
    sha256 cellar: :any_skip_relocation, ventura:        "eaefab700219d4ebd3da557cf92af67c33ee30b1bc129628c8ad2dea8edd3699"
    sha256 cellar: :any_skip_relocation, monterey:       "085d98d867dd60130924ff0e44a2b929f4bfa4081b9fe62d0d3877b68c08afa2"
    sha256 cellar: :any_skip_relocation, big_sur:        "358c7862c36dbd05cb8dfd42d44099644cbc1f220f443649bf01fc8544a3f9ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68c78c49bf23072a4d308ce5b1daf1af52ab1caa3f0962b6cf901bf6cc0ddbe1"
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