class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.40.tar.gz"
  sha256 "05476e0f943846d0114d94fcf620eb088e290f120a59ddcf085b546de7abe766"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eac21995bba33f2a34eb50b7ff20dc01f3cfc3e6a38abd6f8bf9da6f72540758"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd986e3057e68b8821563ae7ba376c17846d02a6b48d0e44d422e3ba575ef099"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5a794b05abe8511a9f6b65795b0af4892a8e11dbd92fa5d8633eb0e19fba735"
    sha256 cellar: :any_skip_relocation, sonoma:        "697c393c4a98c9129639880d416106dc62b469212e596e4fa58fe3c22424e836"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b94f197fe1ee24060a5b69f3b3006bbf1890849aa4f0d1fabe82e04d6e0d093a"
    sha256 cellar: :any,                 x86_64_linux:  "b0682c90fe0e4a4e3188924f223dfb986c45eeebf35ddfcff1a7764c6417a34d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "cdncheck", shell_output("#{bin}/cdncheck -i 1.1.1.1 2>&1")
  end
end