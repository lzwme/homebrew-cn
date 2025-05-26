class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https:projectdiscovery.io"
  url "https:github.comprojectdiscoverycdncheckarchiverefstagsv1.1.20.tar.gz"
  sha256 "6b69cbbd79bed2c109d8a5f204b307c416ba6408ee3e904841a2b959fbcfc8d3"
  license "MIT"
  head "https:github.comprojectdiscoverycdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9e5fe42989f8852dd3e8371400bd3af3f017ee82bd5ccd66c681b98dcdf8cff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "442ab26ef44aa221cd6dfb53b20a60f28a37efe51db7e6622d396cbb340a2b60"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2da911a3cadd11a514e952646a985a1003cd545c707ca5feece8763e14f20148"
    sha256 cellar: :any_skip_relocation, sonoma:        "91262e4e8f809c4236e11a79c55dd634d5369408de69acfe7135cc12c353ba1d"
    sha256 cellar: :any_skip_relocation, ventura:       "97cfcbfda54b589aa86a84ba03d48fb9773e378f9d68a7dd622e019d4bd28b16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85460dcf21fed1725c8f081f02072b93ba9a8c8d7f13e3c0ae63a51d652bec90"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdcdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}cdncheck -i 173.245.48.1232 2>&1")
  end
end