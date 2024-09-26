class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https:onflow.org"
  url "https:github.comonflowflow-cliarchiverefstagsv2.0.6.tar.gz"
  sha256 "d8f2e9c2115416cb670a83be580267cc1ed70ac2dc048c9c5bf2484331b0a159"
  license "Apache-2.0"
  head "https:github.comonflowflow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "498288a4082c47146e0d1736be6f7213f4186189636772b2dfc8345eb456b4c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66659182106d8b16bf49a9dcc519ebd470dea9bd9ad3784195180102460e108e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0eb6c4f413b0dbc970c0761a7cb2e05d79d03b1aa87e3bf4b1029de3bfb1f07c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1149eb2bc7f2ed45fce3aa7a2b8797266327a09c820019d5bebd30e61404f07c"
    sha256 cellar: :any_skip_relocation, ventura:       "ac290e5234f4d73f307691d7330e74bf1a197c70141d7ef94299d1160c1f2dd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99ff8b8e17c4e988a0bbdc53150b4527b787fd09a8e0be3c03372d40708f72ca"
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