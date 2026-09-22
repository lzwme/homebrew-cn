class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghfast.top/https://github.com/kubeshop/testkube/archive/refs/tags/2.13.3.tar.gz"
  sha256 "45987289672012bb00170d5db9f46facb952f8e2501f14126c3672d1748cff0e"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1c5912f05bc0975dec1e9c4f4e6cec27b7e3282f62ddd52c02194527c4445c37"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f6c9ce71b65c9d5678b7241123b6b0ad175353d99f218d93485d90b33e463967"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e0f46067e1947714cb33a9fe838741e151ea311703a74ec32620299f5773c691"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0901052c7ae1a0d5bf1d42c47b1ce926090364586cf873079708737fc2c4a057"
    sha256 cellar: :any,                 x86_64_linux:      "01466cae3ff384d3d405503f510017feae935015ac40b4b677d7a29cafe90527"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-testkube"), "./cmd/kubectl-testkube"
    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get testworkflow 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end