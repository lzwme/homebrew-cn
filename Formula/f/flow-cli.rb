class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https:onflow.org"
  url "https:github.comonflowflow-cliarchiverefstagsv2.0.0.tar.gz"
  sha256 "5767f8e2a1ff8ec4fbd4b04ddcdc0509fcc9e7cb24cfc02d7ec87f847ed9c222"
  license "Apache-2.0"
  head "https:github.comonflowflow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8a8552081f143b34a830915a7cd386d68208ef898395e26bc7d0eb96e44139b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8cb827a971d12ec84f12b3ea113a523b54c8f2ba6c506ebdad98a3a64a38e273"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb619fe781304f8447723273e9b38e4109348a8decab02ccd79918abd38f3699"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ef0e0340b28a559c0ae690b62c46ca5308054b794bcb6c79283d1477e9d2ca9"
    sha256 cellar: :any_skip_relocation, ventura:        "327fdc062187fdf26bf213d135b34bb1c52980f5f353f8a300f94469243211e7"
    sha256 cellar: :any_skip_relocation, monterey:       "1d0ff52c96d729e2c54aa7f18072326a3a59e2137629ec70eef623131272ca2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b20a976b339c29908288e8c8ae86b78dd7d55797f12abbd58dcce5054e2ee8bb"
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