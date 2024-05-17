class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https:onflow.org"
  url "https:github.comonflowflow-cliarchiverefstagsv1.19.0.tar.gz"
  sha256 "2e12067bd4a4a5034b26c0860c96d17790e6c089aac869705edfa610fd65a7b6"
  license "Apache-2.0"
  head "https:github.comonflowflow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54328c43f3d453e97b582952b280fb0c8e20de144984c0a5eb8134db2f80b4aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78c20a4b75795b44833dd1413e2a61ee5a850686b3f3994e208b09b6b7fdc655"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05406c2886a712cd515804468e7fa62d400bc7e8758cf295936f2603374ef7e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "e09688f938040ce6d7e612449eead6a062528266af25479577869e003f22fafa"
    sha256 cellar: :any_skip_relocation, ventura:        "65464161c28e891410e3d9efb144decebfc0d9084ae41f3b3d83bfeb4e325c4f"
    sha256 cellar: :any_skip_relocation, monterey:       "987f11235e2199d5aa02103fddba12196dd282f67a5d87b600180f71da5e87dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4f69a02683e42bc8dc3aea18282c1decc571e29cfa215ed0af788607f36fbe4"
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