class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://ghfast.top/https://github.com/sunny0826/kubecm/archive/refs/tags/v0.33.2.tar.gz"
  sha256 "34a371f60988aebdcd65d18c8563a22191ec3420609021d9ee2d13e87530794a"
  license "Apache-2.0"
  head "https://github.com/sunny0826/kubecm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04b4870cc03e2248297331f542e51bab51ce68c96000bb5874b33809aafcd9a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04b4870cc03e2248297331f542e51bab51ce68c96000bb5874b33809aafcd9a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04b4870cc03e2248297331f542e51bab51ce68c96000bb5874b33809aafcd9a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "feed3f05b5f057fffb3ed485c60ab9ae2d25b990a02b0c114a461c4233399091"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93335141c2272d538efa426c33553318254a974ccbe78e29352dbc4ae3771e33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b121a49e96f08fad9d4f3cb7a10383558e3eaed874245992be76050869bf83e0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sunny0826/kubecm/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubecm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubecm version")
    # Should error out as switch context need kubeconfig
    assert_match "Error: open", shell_output("#{bin}/kubecm switch 2>&1", 1)
  end
end