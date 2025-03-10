class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https:projectdiscovery.io"
  url "https:github.comprojectdiscoverycdncheckarchiverefstagsv1.1.9.tar.gz"
  sha256 "a1e1e86309c44b81a40d258505517d1071ec6d3d4e7599836f6ee95b114dde01"
  license "MIT"
  head "https:github.comprojectdiscoverycdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7f3e75b164947a0bf5032a8cc101d4fc1459d9499be52a6de829152df4e6b08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a062719a3ac34239bf19638ca359878eda465ff30045a39c628d44a6384b378"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d588f0612ae4d3b67f5ec685677dd5cac99254a21dfca54c553b5a131367c89f"
    sha256 cellar: :any_skip_relocation, sonoma:        "512e72037305fc6d73a28587be401f05abd8e648bbaf4066c56f9b26707f5364"
    sha256 cellar: :any_skip_relocation, ventura:       "2eb90eb0b0649cb932c7037b23218d7d7e8b1993102e0b37a386324b15d099d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09a73a92e33adf54f7b900206bb4a93324b5c530ea5c93a3e2178f39aca61e48"
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