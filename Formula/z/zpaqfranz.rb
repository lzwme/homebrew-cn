class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https:github.comfcorbellizpaqfranz"
  url "https:github.comfcorbellizpaqfranzarchiverefstags60.4.tar.gz"
  sha256 "5e5da2162f87a5f001a8e9befd348991adaa33f08feb692c6fc0ff5407706ea3"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https:github.comfcorbellizpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :url
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e4c19c957d83985937ba1383bb27ac44fd6051667726738f340a717818946d6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94ef01637a1fafa74e82665f0febb622c19abdb8ec8deb171c060bd55b948b4d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c485faf4d77f59ddbe902b2025fe9779737b0c0fbd6206fef3d26de21449f8a"
    sha256 cellar: :any_skip_relocation, sonoma:         "1832374b24e7b2529f8184626cb688e150d1de96e9b253024b308d19ce44bbf2"
    sha256 cellar: :any_skip_relocation, ventura:        "039acff6b9b053d387f5a0a040f738f8478b6208f23f95f312b6d0bd47322afa"
    sha256 cellar: :any_skip_relocation, monterey:       "304cdb1858607913145f48422fbbfa76e38e60ae5487af8b8cc1f9b27a9c84e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ec669d68e5f0b53b6fe23d5638038c921069aef25e42c37d1261a526f1e60c5"
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