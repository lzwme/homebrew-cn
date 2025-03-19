class Krew < Formula
  desc "Package manager for kubectl plugins"
  homepage "https:sigs.k8s.iokrew"
  url "https:github.comkubernetes-sigskrew.git",
      tag:      "v0.4.5",
      revision: "e7e5b619d0defd3fe53f66ce7e7330b21386e944"
  license "Apache-2.0"
  head "https:github.comkubernetes-sigskrew.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2612180540b05504e2f9c3aae82cb6335ffa55e88ac9e27f2bdad18390c22dc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2612180540b05504e2f9c3aae82cb6335ffa55e88ac9e27f2bdad18390c22dc0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2612180540b05504e2f9c3aae82cb6335ffa55e88ac9e27f2bdad18390c22dc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "97a497441f46ee46bd7c458d3d369697ca2fe43c75fc58a861db755a2d205ff5"
    sha256 cellar: :any_skip_relocation, ventura:       "97a497441f46ee46bd7c458d3d369697ca2fe43c75fc58a861db755a2d205ff5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67e4f1ed2eb1d0d9871d87749e10251448e279bafbfe74ab1e13229cb3151841"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -w
      -X sigs.k8s.iokrewinternalversion.gitCommit=#{Utils.git_short_head(length: 8)}
      -X sigs.k8s.iokrewinternalversion.gitTag=v#{version}
    ]

    system "go", "build", *std_go_args(output: bin"kubectl-krew", ldflags:, tags: "netgo"), ".cmdkrew"
  end

  test do
    ENV["KREW_ROOT"] = testpath
    kubectl = Formula["kubernetes-cli"].opt_bin"kubectl"

    system bin"kubectl-krew", "update"
    system bin"kubectl-krew", "install", "ctx"
    assert_path_exists testpath"binkubectl-ctx"

    assert_match "v#{version}", shell_output("#{bin}kubectl-krew version")
    assert_match (HOMEBREW_PREFIX"binkubectl-krew").to_s, shell_output("#{kubectl} plugin list")
  end
end