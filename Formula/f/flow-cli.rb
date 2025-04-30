class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https:onflow.org"
  url "https:github.comonflowflow-cliarchiverefstagsv2.2.12.tar.gz"
  sha256 "4a006671c3bf72b5ad0dd6434afb5e819937668e49c4b6fdf25f941937c0cf5b"
  license "Apache-2.0"
  head "https:github.comonflowflow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f52fd549d1b0b2bb6b77deeec865a2b74ff30b2ce7cddb6a96c6e923f07c1093"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8369af8c6190858fa083c937614a4751c6e6db9cc9d7f910f523e17c1fca02de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44d9483c9eaf3fb041c7426d95687d5feaa1a6989988c88728d100afcbe712da"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5a3a11db42c62d8b8c9ea0c2dc3ce31ef0cfbb5a50c6ec2e9ba0e83a5910be2"
    sha256 cellar: :any_skip_relocation, ventura:       "d25ee65daa18baa03061d2272797fe9311cb161b0eeebd61426c63e74878a8de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e70383c5b2570253b8b1a69682402d7ad063c05d5cd0f52399ce2f95a479459"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad0f47b86504e25547c705d17ae86aa2c2e5132f33f3bc1f1f9a4b31a8fa4c35"
  end

  depends_on "go@1.23" => :build # crashes with go 1.24, see https:github.comonflowflow-cliissues1902

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