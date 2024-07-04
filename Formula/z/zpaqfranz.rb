class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https:github.comfcorbellizpaqfranz"
  url "https:github.comfcorbellizpaqfranzarchiverefstags60.2.tar.gz"
  sha256 "9867c542392c4fca86e744eddb9197f13ca194ad9181d064adbb5fff98b0ac39"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https:github.comfcorbellizpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :url
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0270a8f7c44db1db7a12a4bc76a4593b7ad0834bc21a4a88a1575c1e785112e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e77e4f0d63f7d86ee3d0a3bd61b7b2aafd9acdc52d52abafb18a5c0f59ac09c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e5efcf0bd3325093e9905d289f84be9317b38e8fbd30d39dcf8629e8a1fdd90"
    sha256 cellar: :any_skip_relocation, sonoma:         "d2e4d6a8ae09938a4d57304cab827fc7a04198121b3eaebd3a6598962df1ea8b"
    sha256 cellar: :any_skip_relocation, ventura:        "3b121111e42296345db317814b7c5bedddc408a0c95d6bd065ec023fe88386fd"
    sha256 cellar: :any_skip_relocation, monterey:       "73f5b55d6b661c296b9a6fb74a3e58fdb089f0522624a2582a450b77db292ed8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d10eab482450b4cf446cc7bb6fc9b8abe1ef611f7786071ac4da5e0d238d6a03"
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