class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://ghproxy.com/https://github.com/kubernetes/kops/archive/v1.25.4.tar.gz"
  sha256 "fad26b572d8b684d5840a3ddf15502a3f91faf982bbf43e5eb5d942729c3ec9e"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "737f12c6dbc9fe0fff366f0b6b2bac765a3b304c6de9e9d7d5e5dc4bb74ff0d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7aca85e14dc144fd2b625472268a3eb3f134af3eef5ca185e746eb72c1a6335"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7484b2d751b5f6690a8990edaf2cb5ca4140752fe3fde3cdb7b5b3072fb9c05a"
    sha256 cellar: :any_skip_relocation, ventura:        "410e13bac802d79c718d89ce9d8727fe89c85b5068fe1d5f82ea5cb6cd93cb2a"
    sha256 cellar: :any_skip_relocation, monterey:       "a2296314eed32109ca7d5d128bde469254e6aa51a15ed5b62aa9c98b44e98604"
    sha256 cellar: :any_skip_relocation, big_sur:        "c783fd0e548e12b01953a6916b48650fb490b431f5ac8543bd14d6f6a6efd98f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "715ed812eee3f46f94e336b755aeacaac4739afb699ea43cb89234864b266809"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X k8s.io/kops.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "k8s.io/kops/cmd/kops"

    generate_completions_from_executable(bin/"kops", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kops version")
    assert_match "no context set in kubecfg", shell_output("#{bin}/kops validate cluster 2>&1", 1)
  end
end