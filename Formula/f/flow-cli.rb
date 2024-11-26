class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https:onflow.org"
  url "https:github.comonflowflow-cliarchiverefstagsv2.2.0.tar.gz"
  sha256 "f8148c828355a79862a984343677b5e4db9f62a12f5e08d7a3099f410f93b316"
  license "Apache-2.0"
  head "https:github.comonflowflow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e039e38960166d0c4e6cdceb6ab53b8844173296e30b24bea395e3fa9c1ebcb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56742110dbb9575cd921e0ff81a6631beec3d4a6f2c52c9852339fa2f1abcdd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a30f4896b351fccce5720f9a15b9684e7bee0fea152e39b8274f264d62617fed"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad6dc53144b8155383b5322a733d993aa1fd837162736955a214c51f0525ce69"
    sha256 cellar: :any_skip_relocation, ventura:       "c52d8cb87b031bcabba3419c59d7b236ccd7b626ccf61dcd344ffe77a3960106"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ea9a766f92ecf6702f89a95cd61f06e0ebdf16c111808483ba7cad820dc73bd"
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