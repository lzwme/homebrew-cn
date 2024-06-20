class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https:github.comfcorbellizpaqfranz"
  url "https:github.comfcorbellizpaqfranzarchiverefstags59.8.tar.gz"
  sha256 "55a698ea287bb320f1c2667457b8e4ce0f9cbe7577e02a9f2adb834817aaa4b6"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https:github.comfcorbellizpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :url
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a315cdf94c163281889a5c46434fc7282a446ba622c14ff93558b08301081d36"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "651bd6a73a0ff44cad725847dcff49e19aa7a32917cb9aab04687310c207ab6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdda6be3753ca66c54c513ad600a06ca11b73d2249e6ecc6ce48722a8b1b8063"
    sha256 cellar: :any_skip_relocation, sonoma:         "49ede864bcd0bf06945c15371cd75a7b9fba6bd7373c1dbd559610a6c8e56e53"
    sha256 cellar: :any_skip_relocation, ventura:        "ce19509415e8222bafd7349585b99f466bf8bc24193c20641044dbdfd7524dd4"
    sha256 cellar: :any_skip_relocation, monterey:       "1b122eb8915ee30d447a3ba12681e80547b4314a8f7a127afbf2152ad97dddb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "243dc3411a2ace4b20eb44b3b53f19f60e64592ea176e33f58de6aac7a80ab50"
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