class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://ghfast.top/https://github.com/kubernetes/kops/archive/refs/tags/v1.33.0.tar.gz"
  sha256 "05e51f9479fb9867c6fd2eddb234e40ba402169052310f2447f00ca19998aed6"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "507c39fcd8f698a735d459f1b606c6ef07d8e8cae61d7ce77e8b913ac05d5421"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b166157b2a0bcca12de36b3e4fb44c54ebbe691e175fb2bbaede267dce3d88d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c92b634149aec8490cb1aa4608bf747a1a9ba29a2b683164e24de9e161c4cee9"
    sha256 cellar: :any_skip_relocation, sonoma:        "10a2f38b70417f87af07b7ea4fa66128ff1cb05d687efcf0331bbaa107cabd88"
    sha256 cellar: :any_skip_relocation, ventura:       "f71718e9d2aa30022b12d6b5d5e06b9a7bb7a289dc63d185604f5c47b229f717"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9868171d8c23e863a93b9557c70fb82b9f2ec586f5afc29e2a514048c1053914"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f92755f4e7f99ec5b45c01b60896f47398fc2c15fd525986111b213287e90dd5"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X k8s.io/kops.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "k8s.io/kops/cmd/kops"

    generate_completions_from_executable(bin/"kops", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kops version")
    assert_match "no context set in kubecfg", shell_output("#{bin}/kops validate cluster 2>&1", 1)
  end
end