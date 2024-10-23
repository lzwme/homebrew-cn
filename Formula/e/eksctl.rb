class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https:eksctl.io"
  url "https:github.comeksctl-ioeksctl.git",
      tag:      "0.194.0",
      revision: "02ef28ee3d600082f23020999041d6d816377de3"
  license "Apache-2.0"
  head "https:github.comeksctl-ioeksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66637b8263c143b2da35a3b53547316527f604270ccf10e38c72dd56927d53d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4823033684b5ee4f712797a597474d7446a8ed9d94787d3aa8a5a86b0d349e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c09edec48dcd92681c285a046a232f4fceabdb47ac24af6e5094ded8bea03c78"
    sha256 cellar: :any_skip_relocation, sonoma:        "21428b732f7878b69f25400ed0c16acd0cec4b1dfe69de4bbe1964527dc70397"
    sha256 cellar: :any_skip_relocation, ventura:       "949dfa311d4192e8f5e373962ad36bbd29fa2202a1079a6bdc1a26ad934f796d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfdd5c3184e89b12d9f353b2e17ffd18377b771b209b63c4203ba0591dc070c9"
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "ifacemaker" => :build
  depends_on "mockery" => :build

  def install
    ENV["GOBIN"] = HOMEBREW_PREFIX"bin"
    ENV.deparallelize # Makefile prerequisites need to be run in order
    system "make", "build"
    bin.install "eksctl"

    generate_completions_from_executable(bin"eksctl", "completion")
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}eksctl create nodegroup 2>&1", 1)
  end
end