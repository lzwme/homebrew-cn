class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://ghfast.top/https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/63.2.tar.gz"
  sha256 "3d641f269a97f20f7425019928a644cf6b564de635e7b3a56dc8d31eb11e8c5b"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2184a6f7fe0dc84db19b150ea258f26539450bb8dfa0a3b3b561b81bd41eba6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81b0592e7ffd273b339404841f5f66b15134f234db49251f0d8ded695994f1ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eced8b98c355ad13b188c0f99ceef38537bccf26892fc37536de72602ca223f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "814e08949dcd02bbb9bda37c4ed83a97d9b61a4fa0b9ba28be1a8534c459cdfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b2c3369e0d0bee747ae69cb183e591b8aa8ac2c2d060800734830d4c6a108ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17c6d2a9b709d4d4cd0ea688d6d75672f61a3c7b803a1ec761cfa6f2d023865e"
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