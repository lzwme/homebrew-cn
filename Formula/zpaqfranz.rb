class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://ghproxy.com/https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/58.5.tar.gz"
  sha256 "6abb83b77782aeaddb6a429bc433ab8b741a35a2feda0c49cc20d4fc410e37e4"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :url
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "327f8ca7820074e0b732ae5ff140f1d152e459627ab4b9b46d5b3e5952666e57"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09683df765f2765a2fbcb8f913b0271021989c87835d63e23913a4bdb0988d72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e686ba66dda457248c082127a28c90a21b6f61e6bf66bc0cc3a88d000dc49a61"
    sha256 cellar: :any_skip_relocation, ventura:        "f2e79c944e78058b0910a0c84e607023b4dbeaefa594fb7fdacc7cbe41288d14"
    sha256 cellar: :any_skip_relocation, monterey:       "d629b7b81c6af05f62f3c426c95ef10f3e242c4911e0412b5e979767a4b6b5d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ff458e12c78d28ac9e9e9a8fb20c65da9f5cc662d66a65522ed4e55900ed6e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36c9659bc82fb7580d7eaf9af8a10534cb91bd8aa6da588bcb0557b73e8004b9"
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