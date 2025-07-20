class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://ghfast.top/https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/62.3.tar.gz"
  sha256 "abdb6020324560261516088d56b714ab2b04fec9fb7626f0fe1926006a52a219"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81893b4ea9c02bc8e6c5f0193f39235841ed7119027f0cda4c19b188d0901bcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c91589cdcca801fc9a3ed2d1b05caf45c7e35f001df0d1828a24cd4019e571d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ea2fdfd70104e1eb409fb3ad9be10c45588d4cc1cb55bdf01058a46d6bb9c19"
    sha256 cellar: :any_skip_relocation, sonoma:        "96d0b66a3e5b96779e112fd70576ecdc4984ecf4652cdccad66ab7f52241d380"
    sha256 cellar: :any_skip_relocation, ventura:       "93315a997707f5657b560cf995f4bcedec94a57ee8aed5f97c5c6e04a38de86c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3218cbcd6316c32c5a4e4fa371607a5d5a5340cc6c5f2f9dcedf4e6b506912ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bf6521698b2c4df750dcc300e7356758b723d90ba936d208d53b643f2728824"
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