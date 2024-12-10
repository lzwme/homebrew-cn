class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https:onflow.org"
  url "https:github.comonflowflow-cliarchiverefstagsv2.2.2.tar.gz"
  sha256 "8090e3f644c5d380de69b984bb1a7a7a03288115e8eaf7f7512718eda3d3d29c"
  license "Apache-2.0"
  head "https:github.comonflowflow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eabc728a23bf5fc59cba7db0eb41232b59e938145e1083080aa36632d3743ab6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3c020d2011798e21872907b5e1b84a1eedc635e1acdb8c7b8226f60fb383290"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91e5567f82b4bb43461b9ef6c5c921a31fd109d1bf06c594915e2c87427d7719"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e4de02a8fb4667824ce684904ca1e95dfef624df5b2c2b13903513243324594"
    sha256 cellar: :any_skip_relocation, ventura:       "fd9ab0b08e8f3a2240b6e6a4e74613ce05643383f43e58894209d08d023f0b3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d8a37c05b793a5a73bd71d81d59209f3cba7dccd41776a8cc621ecbe792ab5b"
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