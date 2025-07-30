class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://ghfast.top/https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/62.5.tar.gz"
  sha256 "dbe8f7fcdf2453d6a6975c637489e6a38333df098ee40e64039a1145de7884da"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ee2036ad2973e8d1d2422640a16c4b2aa9183e04534cb2e5ab5d5730b08db7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "754969629868825f41b39924b89f609bcdfea9a01fda67f958faae4f66d8c252"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8261a3e95ee13f2eab87e11fce11ebc5962d6c95ffa70446c9d81ee2d5dc120c"
    sha256 cellar: :any_skip_relocation, sonoma:        "cad7abaf8ada2ea44129bb11b397ce6e5c1935f97a0e6172e237cfd401705d2c"
    sha256 cellar: :any_skip_relocation, ventura:       "534eb15a8694e44b2fdaf0f124e139c5984b7c9628d66c8661a1f8855363f18c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a559080d6c4ce1617b9422ffe26472356f4070cb3eb5d2db9a627d4607e06fa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad2e841816293f8f9732a6b9007e5aaba157952e41c3e1cf3099c2770bc9e38e"
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