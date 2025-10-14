class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://ghfast.top/https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/63.5.tar.gz"
  sha256 "b75638bb7caaf596fbd831540c6a765e53e6f1d8f1ca52bef5e5f8baa7f2edfe"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49beefc0d7c1587d16edb6f76d41d64dc55642e471ef61dbc479a81fd7ef7b8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82af1e81e4050293fe006e38b706e8e8c68d9d7ff7958a598bd2ff7c254a6ef8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "709b786a8d3d531894697c4eaba5b636559d386de627507721a46b0aa27a05b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc48821361a82062b0056f4eeb80ab63b55dc8e38c84a76d2eee9d61f58bc34f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92774ae4d25c4caa08310e2b2b8077aa09e6998c93eca12549cf37774845c40e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3aec21b0971794f7b19ae31742a3cc85508ef0133e8d2a6e0ecdbe43759192d1"
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