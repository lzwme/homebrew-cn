class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://ghfast.top/https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/65.4.tar.gz"
  sha256 "92c84b7e7bd9c4177cbc0851947f4a3f0f5b61d1d8c61a3b48e0293e487865d0"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0eecd92d59debccbdd2cc8dec3076914ce9538690315aacba1b22c4d38dd438d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dcb576e7bb2b957e606eca83ffa1d4007f66627385b31b3dfb4d1d10a5d2c7d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6186ff722aee3038e385f78c3c2b43cca48d5322b76f6f84dc468c13956e5d64"
    sha256 cellar: :any,                 arm64_linux:       "0db2e1cd1a0c94bc16da845f63c0dd2e17b67ecea706e43b5d9d7f4d8af18c1b"
    sha256 cellar: :any,                 x86_64_linux:      "f31c21292072a31fae2fefacedee8cba03328140c4c0ee6267df3480f77de0fc"
  end

  deny_network_access!

  def install
    bin.mkdir

    # JIT only works on Intel (might work on Linux aarch64, but not Apple Silicon)
    ENV.append_to_cflags "-DNOJIT" unless Hardware::CPU.intel?

    system "make", "install", "-f", "NONWINDOWS/Makefile", "BINDIR=#{bin}/#{name}"
    man1.install Utils::Gzip.compress("man/zpaqfranz.1")
  end

  test do
    output = shell_output("#{bin}/zpaqfranz autotest")
    assert_match "ERROR 0", output
  end
end