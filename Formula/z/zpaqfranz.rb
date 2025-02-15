class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https:github.comfcorbellizpaqfranz"
  url "https:github.comfcorbellizpaqfranzarchiverefstags61.1.tar.gz"
  sha256 "d6fa47b78866da1fbc9f7ec63a6b99c5ef76bfbdbeec43f78467367a87376798"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https:github.comfcorbellizpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9ca3c568c9450b3b9e5dfade931219b201f675fb19d476239fbd94e56b72125"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0bd885d9c0c0c3a0582790c39f37bd28cccd9478ad3d01de8be58856b0abe07"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bd8fdec0dea75b38cdaad97b8d0f77193574e2763efaa80b230bc50e6ae6cb6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "28aa5c37eaaffb755088afb996036dc523794500a69d44d0374c5f1a3bfab25e"
    sha256 cellar: :any_skip_relocation, ventura:       "08217457107ae0ed613410c693852eedcf8caa0cd194abbba78d6f66b11cfe86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c47e5617c63b158eefb400168e1308de69ae8f61947ef8f5308bda16a7251cd7"
  end

  def install
    bin.mkdir

    # JIT only works on Intel (might work on Linux aarch64, but not Apple Silicon)
    ENV.append_to_cflags "-DNOJIT" unless Hardware::CPU.intel?

    system "make", "install", "-f", "NONWINDOWSMakefile", "BINDIR=#{bin}#{name}"
    man1.install Utils::Gzip.compress("manzpaqfranz.1")
  end

  test do
    system bin"zpaqfranz", "autotest", "-to", testpath"archive"
    system bin"zpaqfranz", "extract", testpath"archivesha256.zpaq", "-to", testpath"out"
    testpath.glob("out*").each do |path|
      assert_equal path.basename.to_s.downcase, Digest::SHA256.hexdigest(path.read)
    end
  end
end