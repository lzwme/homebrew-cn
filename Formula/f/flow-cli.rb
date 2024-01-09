class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https:onflow.org"
  url "https:github.comonflowflow-cliarchiverefstagsv1.10.0.tar.gz"
  sha256 "c73c9d1d0cb968e3de262fe7c60f28c86cedc47901977522b94716471997b716"
  license "Apache-2.0"
  head "https:github.comonflowflow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c07f6bf1484bee49953af8ff945ff999ea7ba3fa6c3b6f0f6e58108a181b965"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0fca8d8ca45cae84022639f71def30c7e1e5a9de87a8051bc1fce91bbf9c9d79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "920b8749dcc7a85114a3ae637493b95e29cfc8c880e2187ebc36641d90dd092c"
    sha256 cellar: :any_skip_relocation, sonoma:         "46558d1457ac08adfc2488d2b9d87eb986ed0ffe09d8c20e5b8337fa89f96c89"
    sha256 cellar: :any_skip_relocation, ventura:        "01eaf7321f187921c4e91f3e5ff330947958cfc24eebd4f936ef61a9e2cef17d"
    sha256 cellar: :any_skip_relocation, monterey:       "48e5d85df0d817eb15717ca42cb14c0e8c7ccc4c5a24a55b2218638907516df7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c3c91baa0ddd3852d07668c7e8106ba2b28f7d86ef9d8c1989587373053c2b9"
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