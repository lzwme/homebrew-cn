class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https:eksctl.io"
  url "https:github.comeksctl-ioeksctl.git",
      tag:      "0.200.0",
      revision: "a1bbbc1dd5056890095a81012626c3fa0ff62e73"
  license "Apache-2.0"
  head "https:github.comeksctl-ioeksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32ed6105799cef82d3828130bd19d2203add1168f545cbb93d9a2da0d1cea710"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37cabaff0016ebabbf857adeab7e131eec72028e0a6b7903f793757b33b4923d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "988013d75c993a372144bc47e2a549347e64123d4144ea3e8e092ae8f33d5e19"
    sha256 cellar: :any_skip_relocation, sonoma:        "3795fa707ce52728de770664931f50098bf2972964181a3f83d43977b760097b"
    sha256 cellar: :any_skip_relocation, ventura:       "15b611c4b6940859c245c6db8885d536104c7f059c96855a3a7808cfdf04d2d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cbb7b55be42be88c71de714b69c986268fcdf9bfba64c68528a4db131fe0c17"
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