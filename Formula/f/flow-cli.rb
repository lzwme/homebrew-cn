class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https:onflow.org"
  url "https:github.comonflowflow-cliarchiverefstagsv1.20.3.tar.gz"
  sha256 "4bac7f410d3838e4fbb1676060bf67b69bb669a9a2866c630c47c7787c99f99b"
  license "Apache-2.0"
  head "https:github.comonflowflow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a48a7e002f034b83f99db06c6a0d963552015c5e77534e6f50b3456bf6d86c3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b5f3e15e71e8635632dc39ac3cffc19a03f1d29f795f2793cb8559160e9119f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e709088028c152f12bb4356b8f4f3571fa4b2d9e9e15e93af99d80ebe37b9d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "810458768cb122bded2665d4f0911d7e8ebf3def99258482a355a9c79acf0af9"
    sha256 cellar: :any_skip_relocation, ventura:        "89119077efad02f97714acefb92ee043bd0ff13e36a40eb3cb2517caf2da3c1e"
    sha256 cellar: :any_skip_relocation, monterey:       "5747e2ad78a4f1c0d2a3e4801b8c63baedda8ef8b16ec30ade5e0cd6187519b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3a0ff8ead8db2f8596d230ecf7052b185b785b3252d1a7e36e0c3f9841f40af"
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