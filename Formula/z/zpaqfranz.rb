class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://ghfast.top/https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/65.16.tar.gz"
  sha256 "e9b4be43004340808719a47e92a2c6a8d14a1cb56d278920036dae080a6f0aff"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "454d287eccbba7a5cd5f1c138e1708765f5d235243e4520a6a548519cca64712"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8f3c6d5240365e2835c77843fb72ab27dc1237e573aaee04f2c6cdb515ae42d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "873cce62670823de0cf457bc3a6374e300fb934e830441de06d9789da8a98ad6"
    sha256 cellar: :any,                 arm64_linux:       "14dab2bfcf41ef182c4a509f885a489b93c82c3fc6e3d48ac333184e40862828"
    sha256 cellar: :any,                 x86_64_linux:      "caaeda016dcddd250c9ac36c9c5312d8927403c26ea03ca2c5f22c32af401f29"
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