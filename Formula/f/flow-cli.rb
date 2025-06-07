class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https:onflow.org"
  url "https:github.comonflowflow-cliarchiverefstagsv2.2.17.tar.gz"
  sha256 "3a521a45352aee7f8dfbba46f95bf5429c1c203b8562f711c19685be43af32a4"
  license "Apache-2.0"
  head "https:github.comonflowflow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d972e2044ed900d8a072c036258076d9eea2b1c6699a9b93834e6c4bdc96ba9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d79b4841e8ca3b70021f5180346757e567995723011d275148826dfe825ef0e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bcb02a8595b495873a636af8f3d245a0baecd1681087bcefa5112e8e732f5086"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b5125bccddcc5fd06e9e34c305293028edcedcb96f948e94f490aaccc1c6ff1"
    sha256 cellar: :any_skip_relocation, ventura:       "fcfc76987971aaa1c4e519dfbb1f1c783a14083537d2f71141dea47e083cd88b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be7259406c2d75104924fb3a9577a18b048a33c584f9d6fa1a172c0340a2b366"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d3ded47c7d787b9745eec74ebb66cfca59c14370a7d6988b5ac40f5a1c4fea4"
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