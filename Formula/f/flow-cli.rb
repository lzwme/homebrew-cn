class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https:onflow.org"
  url "https:github.comonflowflow-cliarchiverefstagsv2.0.4.tar.gz"
  sha256 "62e565f5eadef95848641d9a534bafa0195fa0cc5173fc411eabcac9df475c15"
  license "Apache-2.0"
  head "https:github.comonflowflow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6f1e8791c307a02180983252644341c79dcb5c90aef59669ebec158f8e77a28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6012af0ad0661ced1e7c02f547435579430f49ccd07493514041bc92173a425"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "afc93b838d6843079cb4d0137af5ccb0f913a156d1ec54f0799875ef58121cfb"
    sha256 cellar: :any_skip_relocation, sonoma:        "49fcb40adac6a2053e6c0acb3b529288f350113c047c0c7afe90854767c9c959"
    sha256 cellar: :any_skip_relocation, ventura:       "0af8d542d865a35d06055796508058610953dd0e2870df6af39e72aba572c422"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8eeaaeea490a92a4cbce9a5f52cc22e1ed7cb40abf1f44434df59640dbdd4f5d"
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