class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "978e9af23123e84dd67be15c2b0a89a076f06f2401092488f67a97b1db977c48"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1225fbff3102613b087aa32152cc99e7e02fe099ee8640c7e67720d278c2f307"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "539e010ee2b5dd3cab4914668b246a21a959896db1524a083eb5500207e32d3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afc5932965a0b1be9f1398ffba98e4edf401bc1c8eb3ed3ba78d3c2665e1886e"
    sha256 cellar: :any_skip_relocation, sonoma:        "86cfa6260a2f3dc357cd3d234d397117ee0ed695de133819cee31b36da286949"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c37f16c6d1c813b64a5c4c755bbec7a5b930c6aaa9febaeec478dd566c9a0c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb892d23a63872d47563c4f72c3aa4070c43ce2a88afdeb4c708821817e92762"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}/cdncheck -i 173.245.48.12/32 2>&1")
  end
end