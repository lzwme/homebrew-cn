class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://ghfast.top/https://github.com/kubernetes/kops/archive/refs/tags/v1.36.1.tar.gz"
  sha256 "afd3d4171e61724f5f477e4532bfe8af2285e5b82c422a0f51563d354023255f"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "861f50f2c9ece016b9feb5738568cf6ff81ba13d55e37dedcd01c25c4cffcbf6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d525e9911eed79890c8046f8f7dd692ee067323efce7ea590e583a3a99230cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "989b303460043026f2cd07d30a029acd766745be011ad0d3ea5e13ef11aec5ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "283bead8f72ae30ce201183af05ed580837cd4163b7d8f757ec193b605b49335"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66cc66cc561e85dd2bfc101d0ad39ecadcaa4a362b9a3f4bc7d9c439b16f220b"
    sha256 cellar: :any,                 x86_64_linux:  "8a963fd455f69b2929779e27f0c92699ad88a16b0c6b3d60c9da257a40657220"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = "-X k8s.io/kops.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "k8s.io/kops/cmd/kops"

    generate_completions_from_executable(bin/"kops", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kops version")
    assert_match "no context set in kubecfg", shell_output("#{bin}/kops validate cluster 2>&1", 1)
  end
end