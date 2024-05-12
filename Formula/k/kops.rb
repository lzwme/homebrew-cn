class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https:kops.sigs.k8s.io"
  url "https:github.comkuberneteskopsarchiverefstagsv1.28.5.tar.gz"
  sha256 "fdd1e9210851215a98e7a07f34afba319c47f5bf01b543bf505b5a6fd07aeb87"
  license "Apache-2.0"
  head "https:github.comkuberneteskops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7864a7e7c95488ed857de4004c78f82ac70dcb0bd1927bfea8674f1c54c598a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe9def8e26a00bd8f080343ec8be14f5696060b5722f92ddc453ef05594c3811"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61532940868ffd66896a4d8622849eb102f9a9e6391dca7c0d72fe05d7f1e69b"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec07b452e773595fa6f299b03f36d850ce26c580749c7d9ec6cef94648967c58"
    sha256 cellar: :any_skip_relocation, ventura:        "c513352eecab7741170a7969dca283a25fd2ee52d7cc02df582bd4e06028378b"
    sha256 cellar: :any_skip_relocation, monterey:       "e08acb636ed046b38276ba1ef56d039daa3b64f5c629481d53403d5a785bbc34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e3f3f8dd3c0116f0424f4ddd91fc9045e6c939d6692f380849c2a631e52289c"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X k8s.iokops.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "k8s.iokopscmdkops"

    generate_completions_from_executable(bin"kops", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kops version")
    assert_match "no context set in kubecfg", shell_output("#{bin}kops validate cluster 2>&1", 1)
  end
end