class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https:eksctl.io"
  url "https:github.comeksctl-ioeksctl.git",
      tag:      "0.187.0",
      revision: "707c73b669bc4641bfb0239097fdc970f5bb965d"
  license "Apache-2.0"
  head "https:github.comeksctl-ioeksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66deca3cb8ea1f59d0c97db18c34c41050ca731ff458cefe3d73091364d2b773"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "184bcdb100a149ae8e37c87b60944030d11324e6c4e044fe132228b89edac613"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3959473ca2a9f2c0db87a17266f4c9449714df622db97030d718acb64498f1b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "05e9431029935148e7f62e1b4eddd8d2db0edba5d3d8afafd47de0030798d780"
    sha256 cellar: :any_skip_relocation, ventura:        "c11c9dc1af08fded1df7880160126ae843b004325c3d984e3eedec2ec979c9e2"
    sha256 cellar: :any_skip_relocation, monterey:       "fed418d9197f03d6950267c284e768c9601ccf9f7efec5a91677b2cff6ef9862"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56d6ddea3cbb44a98cdf78775ec6f886c6080ced17ea4710724223581a525af7"
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