class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://ghproxy.com/https://github.com/kubernetes/kops/archive/v1.26.5.tar.gz"
  sha256 "0b3efdd9b953d56e3eafe56d1cb757798bbc095f804943346bf92fb02bfdb0d4"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "247766e5c246b7fbae20240390008c223ee91ce3801b6d08a8d09d08ec545019"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9375593d33cfe26315de8f6e34f8028eb42e82f73f016490bef91dd9cafcfc8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0abea59accf491645772b1e9950a835de750b4ea0431145fc9872fdc5f31c955"
    sha256 cellar: :any_skip_relocation, ventura:        "74a5ff33ffafff46591edbabcf75b0c26dd666b196893250e74fb9fd64213cb9"
    sha256 cellar: :any_skip_relocation, monterey:       "b164a1df8a764131a85c2dfe83c9c442b54682653091c964f41f0bccec10eaa8"
    sha256 cellar: :any_skip_relocation, big_sur:        "a853b3db4413656f054dc99a9f7ca5b82309ba93ffcb03d53dc7db55e3a3e76b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b149d1a3290caf1d25d549770cdc5038ee4f10eac26cebb89baab585bcead6a6"
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