class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https:onflow.org"
  url "https:github.comonflowflow-cliarchiverefstagsv2.0.5.tar.gz"
  sha256 "fce4ed1c0b8ade0f6ce9642e02a66ec1bc73f0e96a85bdff54812242411bfc34"
  license "Apache-2.0"
  head "https:github.comonflowflow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b6ae2aef3e766d4b96808172e8c6e67b12da041fa08885324afa5d088b9a452"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8fa11b5b8010e6a603e61d742e625f5db56620a70bbe16d65a44894d0816d06"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "07389b37b17f7aeba0102839db093b0a25ee96b238754bd64892dca8d9bdb6b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "0dc7eee31337bc509d0c43746ba7b9fe19ec667f39f84385e68225c241f59e92"
    sha256 cellar: :any_skip_relocation, ventura:       "d57414404cf264997b4bdfc56c54b1741f7298c5392a8f621cee69681812530b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "797214d51ef6ea99d778f92fcc5a2fab0a38c457c376cf8d5b03ab0f8a5032b2"
  end

  depends_on "go" => :build

  conflicts_with "flow", because: "both install `flow` binaries"

  def install
    system "make", "cmdflowflow", "VERSION=v#{version}"
    bin.install "cmdflowflow"

    generate_completions_from_executable(bin"flow", "completion", base_name: "flow")
  end

  test do
    (testpath"hello.cdc").write <<~EOS
      access(all) fun main() {
        log("Hello, world!")
      }
    EOS

    system bin"flow", "cadence", "hello.cdc"
  end
end