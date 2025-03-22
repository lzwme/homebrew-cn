class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https:onflow.org"
  url "https:github.comonflowflow-cliarchiverefstagsv2.2.6.tar.gz"
  sha256 "c38b36a2216d74c4783d59a7a2508545b9e30b9f2eebf18ecec2173d9a9539a6"
  license "Apache-2.0"
  head "https:github.comonflowflow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07474a41e5bfca44f67b3107753d487f423675387244126c900f7589e17c0913"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1d7f84619e3367e20c408d25a842201f19e03d85beeaffed1272ea656880816"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aff418b19cbe710dff22ab9dcdcb1c58478e82f7b737fc40ccc73db23ba5127f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f5536ad891ceb9e41e77f2f36c8c927cd54045bd55a78b4aee653371bfe8b38"
    sha256 cellar: :any_skip_relocation, ventura:       "b97f0b8de1f9955f2b4550917e3b8c4ab1798423193b55da2583e2afcc77509f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65292754ffc3cd0e64bc404403aa7c21076486a142e82c8e8d97c4641d1eb4f0"
  end

  depends_on "go" => :build

  conflicts_with "flow", because: "both install `flow` binaries"

  def install
    system "make", "cmdflowflow", "VERSION=v#{version}"
    bin.install "cmdflowflow"

    generate_completions_from_executable(bin"flow", "completion")
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