class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https:onflow.org"
  url "https:github.comonflowflow-cliarchiverefstagsv1.16.0.tar.gz"
  sha256 "b8c4d0fcc35818eb865f01fbae9502fbaeb9708d0c6707ddf1a11d770e9e9402"
  license "Apache-2.0"
  head "https:github.comonflowflow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "556f61914fda8cfb1d8eaa3c1d5763fcdd8bfd2ff6893d3f4e634721ccb27b84"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "833d75158f2016c8cd76bb71be441c2b39c85858c24308e3d789f1c5bced0a90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c21067d58ffdcb1ac6966cd9ceb4e2c668e4f45684144912639e3080ce2bd0f"
    sha256 cellar: :any_skip_relocation, sonoma:         "32a8dd4895f917fe9c71bdb6add44f518ca6760e4ae0126d7db23920e5d8821f"
    sha256 cellar: :any_skip_relocation, ventura:        "c34080efada0320a7be2a53f8e70ca690e9dd12650b6e61e958aa0bd82b4af9f"
    sha256 cellar: :any_skip_relocation, monterey:       "0d4a0f35fb33610708272e92a856c2655495f5fdcee3e3f81f6f8115a623ba1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b58370509e630a05a0a0b44b051031aef29c72782da802d88d8f4c6c55c39735"
  end

  depends_on "go" => :build

  def install
    system "make", "cmdflowflow", "VERSION=v#{version}"
    bin.install "cmdflowflow"

    generate_completions_from_executable(bin"flow", "completion", base_name: "flow")
  end

  test do
    (testpath"hello.cdc").write <<~EOS
      pub fun main() {
        log("Hello, world!")
      }
    EOS
    system "#{bin}flow", "cadence", "hello.cdc"
  end
end