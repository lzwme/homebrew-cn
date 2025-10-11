class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.29.1",
      revision: "7268222bfa05fa359a40e54614a61c137b70ffcc"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79cd7366e15913c72b36324c4b3b2bb99f06a361861ade64428d137084f69f9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9c8749729e564295b015cc3c3760ca630c51d43def282b8453ecf837304ee43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1aa3a1de833d845542e415e4854391900fa973f1317b36ab038bb576ea4e91aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ad3f28dd875d44c2dd7ff372afc84ba1c1334c2416f10e1133a913a4e58cdbb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0dca32e13e0934a80fd4f46be6d03ee154c541a54911be1db42860f8fcda928"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc39da7e631470c6d4efe0ac6f8daf39a8e0854a13e044ef716bf6a6a4f0eb41"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.commitHash=#{Utils.git_head} -X main.buildDate=#{time.iso8601} -X main.version=#{version}"
    system "go", "generate", "./..."
    system "go", "build", "-mod", "vendor", *std_go_args(ldflags:), "./cmd/vclusterctl"

    generate_completions_from_executable(bin/"vcluster", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vcluster version")

    output = shell_output("#{bin}/vcluster create vcluster -n vcluster --create-namespace 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end