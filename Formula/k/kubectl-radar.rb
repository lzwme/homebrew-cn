class KubectlRadar < Formula
  desc "Missing open-source Kubernetes UI with a built-in MCP server for AI agents"
  homepage "https://radarhq.io"
  url "https://ghfast.top/https://github.com/skyhook-io/radar/archive/refs/tags/v1.18.2.tar.gz"
  sha256 "da7ae9618a9f28caec10daa8a6f1ce49cbfcb313b46fb07e24e41d606d7c5891"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8cef20906c31cd3af59fed73cd6e447194a92603d559d0853139bca1eca2af7c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cbcd858929437c592ae028bac9703a8381312fd3792dd2b29623160aee08feb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "13ce9e1edf5693aeeb55732b4b3c8ff7d5782a517fb8905ba6d14f312daa4af5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cacdca2df2f2055929f472a6ec193ae02cf120fd0a17dea04574a37eac053ce5"
    sha256 cellar: :any,                 x86_64_linux:      "d31e6880d9d7bf2af5f8703def5f2c842110f72dc5f6bc936655756198cd181f"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  deny_network_access!

  def fetch
    system "npm", "ci", *std_npm_args(prefix: false)
    system "go", "mod", "download"
  end

  def install
    system "make", "build", "-j1", "VERSION=#{version}"
    bin.install "radar" => "kubectl-radar"
    bin.install_symlink "kubectl-radar" => "radar"
  end

  test do
    assert_equal "radar #{version}", shell_output("#{bin}/kubectl-radar -version").chomp
    assert_match "failed to initialize K8s client",
      shell_output("#{bin}/kubectl-radar 2>&1", 1)
  end
end