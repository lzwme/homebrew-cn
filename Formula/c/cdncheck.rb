class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.8.tar.gz"
  sha256 "b316fb688df924bfc302a1ce7848ef4edb02d6ca9dad38e627efb55b2e97a077"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10b090c0e761caf3ebb233bb6dab85dccd76f5ce05619f471fd289af3824f394"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4326c9938c2cc3acca36c7089241d8b8d509e1134944cf072bb0efbfc7564c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96dd0e60e1e181343293c877a2da2272fcfb2879cb7cfe9364556a14b87fb718"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d6fe9e088855c7c172570305cbf2e2c23efbf0f09294ec0bfb267f3d625a6fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "581fca942a86f1769c09cf810e60553b5459fb2d64b7d987cd9769b7ac899e3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27ced57cb1df78828ec242abf5a974364af35cf6cb3a827bc539568b7222a8bd"
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