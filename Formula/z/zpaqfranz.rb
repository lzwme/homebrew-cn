class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https:github.comfcorbellizpaqfranz"
  url "https:github.comfcorbellizpaqfranzarchiverefstags60.3.tar.gz"
  sha256 "33780bead6022f05c6945b7119b01342809eacdaa4c366b7492df712b881e2f9"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https:github.comfcorbellizpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :url
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d3f15185b791b52f3a60285615e9740f3ec0a315b86f264f059f2450d2fc0aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc1ab931223c6458ec1493f066f2ff2c7bf91b5c1f574ba22bdc2af08f91970d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d05f06ee251d8b5076b5260d56c05af7d85eb881e51011ddff56f8bc0356549"
    sha256 cellar: :any_skip_relocation, sonoma:         "24a4ccfbf41a0c13a1bfb2b1d460e6277ce8747a17032838eee9a1b3d07eceb2"
    sha256 cellar: :any_skip_relocation, ventura:        "80124ac4246038563c5a7aaf6688340f21ebd71eb6384ab3b428d88b0e47a6e2"
    sha256 cellar: :any_skip_relocation, monterey:       "8bcf0fec539a5c9d7bf517b12797d5cf8295d8c3c5b5431d69a863c08de7e532"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9708141b540b8cef1b483a2ae562402ad7ff7566723d25c3ce916ecb19bbb2e2"
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