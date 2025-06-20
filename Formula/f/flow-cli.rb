class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https:onflow.org"
  url "https:github.comonflowflow-cliarchiverefstagsv2.2.18.tar.gz"
  sha256 "e904ad6ecf547e1d960a421a136b629363464f1d3aac555bace05b5d6410d42d"
  license "Apache-2.0"
  head "https:github.comonflowflow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fd4b0791e305977b4df6d950f0de0cbc30e13f93ab4b984075eaa7d12558f9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c992345355271f5da6e10fd5fa48e4f92fb0aeb12dbd5d6fc3c1229759cbfec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b2816b5ad6635bea8b5fc6b0f0d85c4c460a8d04b152c4163571f1ccebb0111b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ad852f979e0aadece0d4a90d65ac8477b9ef2120f3c10c2b2c9b78e7e6377f6"
    sha256 cellar: :any_skip_relocation, ventura:       "c5630af150a617cb544b04e1e29c98492aa7aeb62fbba779e0be69f913c7dad2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4bdd17745e7da5d84846a8efdb80d3b9ec46ac476c60eb4a2145cde80e597d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1f62732f6f52d84416d32cb975331b39565e7ab15bb16a3aa374b78839ec247"
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