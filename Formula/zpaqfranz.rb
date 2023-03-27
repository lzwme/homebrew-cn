class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://ghproxy.com/https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/57.4.tar.gz"
  sha256 "eaf8a37af9eb9184b6c1e58ec237a8582b17096931b2c33eb13d02e1682952d9"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35547fcb098e2c9ba6a9b3a97c33c7b63251eca64c2f2255434bf4714bf1b99a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ef8fce40757ad582d98dee8448d856fff55b9ea5c62845ac67a8522f5918b55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56a90011e9fe15f5802987bb4d8850d2d791b1b0f42fe5b3fe777fc78aa6b14f"
    sha256 cellar: :any_skip_relocation, ventura:        "daf3742b6f070348f604739eec61e4ad94a532c912b3678c660350a7fbcc9398"
    sha256 cellar: :any_skip_relocation, monterey:       "95cfef3ae6d6d5430d473f4b8ac6755d12ecb9559b4c3df4564df499591f1d24"
    sha256 cellar: :any_skip_relocation, big_sur:        "4bf77b13859510afc92ce1b7a9fdfa6a4b51492840486ca9f22a76ebea2e6f69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56b3da3986185c1486f366b06f47e8fb9b20ac2a32ad20812119e006e49b7a34"
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