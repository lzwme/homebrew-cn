class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https:onflow.org"
  url "https:github.comonflowflow-cliarchiverefstagsv2.2.14.tar.gz"
  sha256 "c56bcca9336538e7475c25e7f9a3a5b7525d2e18b841eae714a5a3eea1cd93d4"
  license "Apache-2.0"
  head "https:github.comonflowflow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5053b8a74502ebe8e780d22066a97f4a9ace616e0f9944ca6da10e66dd09f54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea4b3d131ecf2e363d0493f324fca45cf77d400635461e5d7b292099f57e694d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "00ff5bbf48d6683b7143a9ea8cc95382c689482124558e8a7c60c3364fe71d17"
    sha256 cellar: :any_skip_relocation, sonoma:        "d80cd37cf388057aeec56984da88b7db14cd083dd054f45e6f4823a22730976b"
    sha256 cellar: :any_skip_relocation, ventura:       "46e1a1c3d87985fab95fc7be2682b97f0411dbf903502ff9a5196a4cb99a1702"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e123d04caf9178813dc61c61ed70dd681a95edc1fcf9817abfb623ec22106fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2723a7ef6bcbd0a2a6f9b0d888863039e74e6e09801e6bd475123caa4de760ce"
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