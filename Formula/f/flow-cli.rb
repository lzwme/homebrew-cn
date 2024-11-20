class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https:onflow.org"
  url "https:github.comonflowflow-cliarchiverefstagsv2.1.1.tar.gz"
  sha256 "58d8ee38cbfe503d783d78691617e8058213ae3f054183946ec6dc84023be9b2"
  license "Apache-2.0"
  head "https:github.comonflowflow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddade623bb3f375d162b790f735a773cd03881a5a0eab303cf4274e51931aca1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1ceea5e413bcb240843af76542e269000c51013c93b8560e799851e5ae30bc1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d52c550aadf44b5945a816985d6dd3ef72cfc629941c68cf34ebf1283a68c9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "29549d676ba96a85c12be95c73367bce9c52197c9aa0788a5f40e3fd57d7c6b7"
    sha256 cellar: :any_skip_relocation, ventura:       "5f4a579c3cca8000273b596d2d766c3ecaef576a0a1a3a43364f38030225c634"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc278a534a5af54772185fcdcf26b1fca75d674695df620b369ea401e53cc471"
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