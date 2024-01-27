class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https:kops.sigs.k8s.io"
  url "https:github.comkuberneteskopsarchiverefstagsv1.28.3.tar.gz"
  sha256 "b606534b2de2711ad24cb57805da624b031249f1dbab9832039217e3987e1070"
  license "Apache-2.0"
  head "https:github.comkuberneteskops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "70240cd33bf592d4bb939022426b3f261b70ff7389507b26dc903a96383d49cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d84881c85fc00afbbcc4953d2c8aa6647d2b2288f96ccaecbe10f549e30c714c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e8428e3399ad93ba40204f5fb678b76db8cf531c300a1ba7030922d5e7b09c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "00288fe290b0214516c7ff86b06087c826b9a7cfca0054d5dfd97f322802f1f9"
    sha256 cellar: :any_skip_relocation, ventura:        "81a60b92e4edf1478d926a12f236d9daf2539b4ce7aca8e9fd3fe18fa011917e"
    sha256 cellar: :any_skip_relocation, monterey:       "82e59aefbb6097ba9e4b786c7ed3c3b56b771b6073980b93060f22716604dd90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "374c1718e678f93264dd6fc0a0c280bcb2e7b6a3e2e488da19ae9958c43c7864"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X k8s.iokops.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "k8s.iokopscmdkops"

    generate_completions_from_executable(bin"kops", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kops version")
    assert_match "no context set in kubecfg", shell_output("#{bin}kops validate cluster 2>&1", 1)
  end
end