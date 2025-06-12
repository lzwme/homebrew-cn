class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https:www.vcluster.com"
  url "https:github.comloft-shvcluster.git",
      tag:      "v0.25.1",
      revision: "89f49f6ff2e4ccf7def8b11a2d38c12486ac1326"
  license "Apache-2.0"
  head "https:github.comloft-shvcluster.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81c37d1618fa1e514c9b23d53c76c1d87b6d29564d85b778372e86b90fdcb661"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4aa6d675e06522f2de6bda5ee86f68ddc6cecb65a8bdfdec874c995217462f84"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d185b79f0c86bc02dab3e9c52a3565ec49cca84d10eaf97fe1c42555a4744c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6bd189fdbef4027011c0079e1943f4f0a45bc239719cddd3d2ed1c61063ac4d9"
    sha256 cellar: :any_skip_relocation, ventura:       "ded7ddc1d1e404da295698931b81a96514538dd2fed9f5127579180dd721fddf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b09e99b433879536af409c17288707512fd6453d2d10e6dd8a267f451530864f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dea80d08497468163abcce4b43434f61ac2ac2baf8d5e7647d9181e765f2882"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.commitHash=#{Utils.git_head} -X main.buildDate=#{time.iso8601} -X main.version=#{version}"
    system "go", "generate", "...."
    system "go", "build", "-mod", "vendor", *std_go_args(ldflags:), ".cmdvclusterctl"

    generate_completions_from_executable(bin"vcluster", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}vcluster version")

    output = shell_output("#{bin}vcluster create vcluster -n vcluster --create-namespace 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end