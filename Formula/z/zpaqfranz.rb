class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https:github.comfcorbellizpaqfranz"
  url "https:github.comfcorbellizpaqfranzarchiverefstags60.1.tar.gz"
  sha256 "359d89f6fbbea6d730ffd592894a42e5769a10719fc9a5fdc0af2f96ad7e350e"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https:github.comfcorbellizpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :url
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca478083fb365b57a40455a42cc58bc00093660c9e80cc449c692c54cf22677f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "632de85e76ab2d741204b529fc5ecb5f19b0bbb2e8bcaae0eaa952c3a94e1523"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a8276e6bcee0c5b2fa00dfe266530632e476ba2dd8f11c18b30ca3968bcb3bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "e523428c0d96daff23a1e7d230e5695d039b7d81a2d90f329100485d9bdfc8f9"
    sha256 cellar: :any_skip_relocation, ventura:        "f86906cdeeb0fdc11de26a5b3b6815b400be32f9fe9e778f7c9dc92a9a1c8a21"
    sha256 cellar: :any_skip_relocation, monterey:       "0d5cefc706245e44eeb96d56a93510cc892bb23fd082409138045e1b78713af5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8f39af8600e96d63ac57bddd81b4df66ae21fc4009ab9ab6c3d58d667514345"
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