class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://ghfast.top/https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/62.4.tar.gz"
  sha256 "ca907bdd043c7a9866b800c7b809b008003bbfb8e8a5cdaa89fff004e64077c3"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e32872a07150f27f7646b5e6c429a6419818cc31f8daf23fa0de860d588304c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b569f7747e8767188c084a73b988b1bfd7e9d8f0ca6438776527e15d1e26834d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af278e352f56b72888f7ba1266ef821ec52418cf54864169cbb86a2b0d7022b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed94128a9e810b33ba661f41e79138d71435379654f85de0d7b2a76d32713a2b"
    sha256 cellar: :any_skip_relocation, ventura:       "c53baaf26739df0a812449571c412c0e14d590080aaaf71c0e4a93e47b4a175e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f659ef32072200c035492c520c3a8aa0657ea10ad330624b4fd3af0b9b760bd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b80699fdfa41c25d16a1116e3152933d8c691875d9590f30e4492ca5f5a45f6"
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