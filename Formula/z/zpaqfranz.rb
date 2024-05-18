class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https:github.comfcorbellizpaqfranz"
  url "https:github.comfcorbellizpaqfranzarchiverefstags59.6.tar.gz"
  sha256 "762286f444dcbf2f5e07aff2e80311afe31f62490f39fdff97be887c8932bcb0"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https:github.comfcorbellizpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :url
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1b34a9600dd3ac5616371263accb72fe333017339c49267c39cf30fd45f7c171"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e18aeb1d5e036f2bc0c83a2c55a331cc23bf75c574ec9cd596573104b9a0181b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba81aae0735f6bd91a89efe9e8286b7d646136c9cce6797d9c7541ad644b4582"
    sha256 cellar: :any_skip_relocation, sonoma:         "83a53ecf56c347dbbb7d50ffaf17aeb2a6c3eeed86001853b358838b8a233d5f"
    sha256 cellar: :any_skip_relocation, ventura:        "487a3853b7b4b4c6482230ee9cd28933219bba4694265c4393efaeb3abffce6e"
    sha256 cellar: :any_skip_relocation, monterey:       "d5b862c522c20dbfe8a2d58d759d7a14c6b782b6645906f188439dec847dc47a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b358bf7b9f3544b4d9a39b5fd6b099fa7eace7cd3c9720e85ea5ff435832afe3"
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