class Talm < Formula
  desc "Manage Talos Linux configurations the GitOps way"
  homepage "https://github.com/cozystack/talm"
  url "https://ghfast.top/https://github.com/cozystack/talm/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "9c816fdc457175f32379e6ef5a1075bb3f1c1615dda7a64cecee83c65a643eb4"
  license "Apache-2.0"
  head "https://github.com/cozystack/talm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7f4dcb038a016d4b7f3b3ba712905281df52390d976636f93bd89f5d2ffaac9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abbc14d6eed3b65fe188cb8fab1718e17f5076b3c82dfb7d5608974a6cff10af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "598b95c06efd71416e5f8fb0f315347516a06366f6d5a8bae19b7dcf38f749ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "4612ec98de377daab269b2573ea1e700406acfa03bf4db0dd54151d76262bf2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a53ee568779939a9d1f0564606f45f2f3e490d9dbbb828bd2d08ec5f78e18f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7e212f0861fa500dade6a63d3676dfe35773aa9c6c0b01a80a2e81d0ce29460"
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