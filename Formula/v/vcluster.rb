class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.30.3",
      revision: "538bba63cf6f6b52f53b69f5f9418d6343f41b23"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74fd16899f13d220b7e205334ebfdc102b837f4cb74047e898f88f453148cf37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c47fb66b88050330c2814a463728b7c34e674cf752451764ac929f4d21967d68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "575da70f78bbc7648e9b2707517413993b2f82c3c79441832152850f055b408e"
    sha256 cellar: :any_skip_relocation, sonoma:        "243acfd2f11165397c4fed3cd0e7c2f18d43147c4413a6f8f1c5aaa6e06e77f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8aef48ee77f88a558b74e5016e1e541ee224ac14a2cb7f591257975d67eb1c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbf4011ef82fd2ad14aa3f3fd5e22ee59bb1393cc65816575c672350f10c7214"
  end

  depends_on "go" => :build
  depends_on "helm@3"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.commitHash=#{Utils.git_head} -X main.buildDate=#{time.iso8601} -X main.version=#{version}"
    system "go", "generate", "./..."
    system "go", "build", "-mod", "vendor", *std_go_args(ldflags:), "./cmd/vclusterctl"

    generate_completions_from_executable(bin/"vcluster", "completion")
  end

  test do
    ENV.prepend_path "PATH", Formula["helm@3"].opt_bin

    assert_match version.to_s, shell_output("#{bin}/vcluster version")

    output = shell_output("#{bin}/vcluster create vcluster -n vcluster --create-namespace 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end