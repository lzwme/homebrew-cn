class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.37.tar.gz"
  sha256 "0a8ceccb85baea5e14125d177b3b620fe509cc989e9b9a13545f0d954b9b545d"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee2ba76ebc861ba8b9966f176f71e8a363ec50b8849385f779327b296fdcfebc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "512c1d613774a5d786927603bd87f8374f308c5880f5171c661f4781bb8ec217"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c74dcad50b782f31b7da252cf71331e49150402714f46829babe650c31a1055"
    sha256 cellar: :any_skip_relocation, sonoma:        "f89e177cc71b46309d466519160d87552f43a430cd0542332fd89a5aa1979519"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53368a8f8745738c531f06a79de5dc4b72c30d0a2b3f3466ae1b3e8e7d671638"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0dc10f014173232b0592852ce5b6b833346e18ee98b7c276e23d77270191cfb7"
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