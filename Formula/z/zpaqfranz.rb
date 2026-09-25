class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://ghfast.top/https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/65.3.tar.gz"
  sha256 "f9b883e3653acecf2aa82143136a21943871663d53c1186f0c54461189ab47ca"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8af81284d8eb8b0576d8da512f35d33b91d921dd3f6fcc9e72611e417c0e7d22"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dd7dc0c8600b05e00ebba8fb1d075ed11213ad807d2575f0a3b5474a2fac63b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bb99490afd65400ed016db37f4105fcc73753df1ae166fb632e549aa3e371ab7"
    sha256 cellar: :any,                 arm64_linux:       "a9d9100053f379ea048d51b2a4e026c5fbfcc0a1e09864123d60824707f63076"
    sha256 cellar: :any,                 x86_64_linux:      "0a7df6f4e142d37476ab8b3269c210baf88b2b472c2b0975f82ff4d3d4c072ac"
  end

  deny_network_access!

  def install
    bin.mkdir

    # JIT only works on Intel (might work on Linux aarch64, but not Apple Silicon)
    ENV.append_to_cflags "-DNOJIT" unless Hardware::CPU.intel?

    system "make", "install", "-f", "NONWINDOWS/Makefile", "BINDIR=#{bin}/#{name}"
    man1.install Utils::Gzip.compress("man/zpaqfranz.1")
  end

  test do
    output = shell_output("#{bin}/zpaqfranz autotest")
    assert_match "ERROR 0", output
  end
end