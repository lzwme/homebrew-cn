class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https:onflow.org"
  url "https:github.comonflowflow-cliarchiverefstagsv2.2.4.tar.gz"
  sha256 "2ebc1bc886e25910f70ce63a0c33dfffe95dd6e5278781fc4733be400fb20db5"
  license "Apache-2.0"
  head "https:github.comonflowflow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36127ca172971d863838aa3243715a2b53a3b6ad47a855dae4c94a8a023d0962"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d56f7e7da2f727b78c473d0406e37568da19b90280923d6ffa45ad31088527e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5375c979f32c1e5a20332a52e4da870ebfb77f8f68e5d6708c3fc1f4cc3b78b"
    sha256 cellar: :any_skip_relocation, sonoma:        "34af6697365e9634f89a6bd843b3fdb4b61253c452ca5388868b1ba5d7cc20cd"
    sha256 cellar: :any_skip_relocation, ventura:       "9edc5a2941416c0c9648d16cc4d7c52e531676dd01d514759c82a61f3da02cbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15bdc196faed2e642ec743bf84e349b355da8c9ed9dbdb50100dba8de311299a"
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