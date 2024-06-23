class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https:github.comfcorbellizpaqfranz"
  url "https:github.comfcorbellizpaqfranzarchiverefstags59.9.tar.gz"
  sha256 "d29b124c93d1ba93831a0fc95b6ce16dfc02d667f86515720733cd9aa6caf1ef"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https:github.comfcorbellizpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :url
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a62e44f8bf4df43300c4f4335045e90eb9cfab31488c5e8395b30fccfd1bc56f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0cc2909a3143eae27371abc84e04eadd24480f8cc3e0ae1b3fb4b505b6ced673"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2aeea1c9fda07b00568ad5262f316fbaa751402b6c5158b824b52acb14386402"
    sha256 cellar: :any_skip_relocation, sonoma:         "d64365ba488d18ea5039d936953c29de4b241076a44af80c4ae60c9f24882e26"
    sha256 cellar: :any_skip_relocation, ventura:        "292c5ea0c0d27efea7c1740d8367e5b1d9a04fd303a3360d756aa0c956e72801"
    sha256 cellar: :any_skip_relocation, monterey:       "f6577075f887a6f1bc219b7185fa2ee732e779f8f7941efecc157a64cb85faab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8099c04bfd85b2167aa42623fdd8a05633f1ad95c0b07c49e4a2f6b58773591b"
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