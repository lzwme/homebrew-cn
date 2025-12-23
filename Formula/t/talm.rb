class Talm < Formula
  desc "Manage Talos Linux configurations the GitOps way"
  homepage "https://github.com/cozystack/talm"
  url "https://ghfast.top/https://github.com/cozystack/talm/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "17191af770ec13593675208ecb07b8443d41f95b112fd8000b7e85df61410ec6"
  license "Apache-2.0"
  head "https://github.com/cozystack/talm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abd1412ec18c2842eac1e0a6ce8a6c3c91c5a41cc893521d8534b0511f55db66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37873a0cc56a6d307ec0d3b21e31c96026a08ac9227b8438ee1c814dbb57341f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3da111938ddcdb59e3a37b7f572fdcc0bca527e9ba934d72538e5e63b329d229"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e410826ca0729525853021b8d8ec7d154166b0516f1ede7336ae2cca9d3d02b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15f691aa0441acfaab7ee3196fb98447a55fa47afa7cfb9e0ef4cb342a9436a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e63d2c2eda8b08df7220b7f039ce0b3b84cf03c1376eb7eed6708a2d47f87af"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match "talm version #{version}", shell_output("#{bin}/talm --version")
    system bin/"talm", "init", "--preset", "generic"
    assert_path_exists testpath/"Chart.yaml"
  end
end