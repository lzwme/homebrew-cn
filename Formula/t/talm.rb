class Talm < Formula
  desc "Manage Talos Linux configurations the GitOps way"
  homepage "https://github.com/cozystack/talm"
  url "https://ghfast.top/https://github.com/cozystack/talm/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "59bacf691ab94e77a88e8bdca31a30f422ba3bfa9c3a7ffcfeecd68602f16bbc"
  license "Apache-2.0"
  head "https://github.com/cozystack/talm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e1444b8d25fc2d95af90422e1e4d3b58d3e96a4fc35bdfac3cf18f118ab72d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "637e76a143705174dc1df6e49b8095a149479c38a390a8742dc1a729a2c9ffbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f6b11de8623a5bf5f620ba459998f4c05ca4581da51a68bb25bc510bd93e39d"
    sha256 cellar: :any_skip_relocation, sonoma:        "57fda00784cc320e04326a4a334e242f0c73657ae9a2528f983a33d9f0b04d77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33b32adcc1edae6a949964fcef899da5d1509a39224556cf2644f1e9c68ea2cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b5bfb1184e40928e50ca04a0fc3d814f98d0e62c5ca616a5cf2a07e5cddbac5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match "talm version #{version}", shell_output("#{bin}/talm --version")
    system bin/"talm", "init", "--name", "brew", "--preset", "generic"
    assert_path_exists testpath/"Chart.yaml"
  end
end