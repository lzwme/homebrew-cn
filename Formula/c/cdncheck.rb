class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.15.tar.gz"
  sha256 "10761ad3c204ae39e10094bb5e28b415b3c33e63a700553fc629320829b70fed"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0c9b4f4734d1a44bc110ef6fb55590b40c65942d934753e346dd1ddf900658c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75327ba34cc4e481fcd86a312de26c974ab076caa0df4cf0165e1e8c5eafe45f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c2a6344d19601ded919162cc21525ffd40c93443eb0c4cd39bb58fdbc76ce86"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ae50e42619736426ee92b6b61145407c1d7f1e92c33694d365ea2730892ea55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d19226852b5765ef216057dc237cb3f657bef13e07672a1756eeac068beceb81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61d959163b9b682a3e1e51daaad25001a7f10c5028c52834ad92ca49f74e2496"
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