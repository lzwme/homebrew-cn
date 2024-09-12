class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https:eksctl.io"
  url "https:github.comeksctl-ioeksctl.git",
      tag:      "0.190.0",
      revision: "3fccc8ed8683e2c5bf2e524ec93e30e5b41f3642"
  license "Apache-2.0"
  head "https:github.comeksctl-ioeksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8a7abd5b561fe510baa4e40d8dbe8d818c957e9dda43b8da0461a55c51067579"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f7bfcd3db7da1bd7c505b555bc658b82baa2e2ecf43cd1c05e20e5932fd62146"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e27d4f898493b681c02abf304fd3beb9b32802617dd2009fe7b7ab967e52ad5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa99e7cf294b9512093727115ae7c1a34c3ef93da4e38125145724120daeadf0"
    sha256 cellar: :any_skip_relocation, sonoma:         "afc84997802fce329c76cb95e7bb3eb7f295df3e71a08e905192d0dc69ea00dd"
    sha256 cellar: :any_skip_relocation, ventura:        "272c0a9568647f96b9cc079c07a1bb32452964606fbe4725f7b816c49a49ed19"
    sha256 cellar: :any_skip_relocation, monterey:       "6818d747ced51dad35554c9ff9d2c6f2db43afde8584708bc4eccaa53f75c56f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b289a5b91b16392475e0503b2bd91f6f9ca2735b11197d13ca3ffaf1ec75b03a"
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