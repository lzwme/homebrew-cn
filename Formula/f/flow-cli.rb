class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https:onflow.org"
  url "https:github.comonflowflow-cliarchiverefstagsv1.11.0.tar.gz"
  sha256 "8ff27a42087e294ddd1d6f20844e5f8c768e319c6ff4fc972262ccc8f8696f43"
  license "Apache-2.0"
  head "https:github.comonflowflow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1029c46077ec865ab7b7dda75c026a4d131f2f8494b3ac4a5e04d8fa0fb799b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3fc4016ae472f74aa17aa1d99dd3f679e906e0c4a7268eb2610fbbda752ddb96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "641360f99ef65618072ef35d271dd5ed2e3939e172e8119e592f629b9ae0b03b"
    sha256 cellar: :any_skip_relocation, sonoma:         "394e764ea20cc2b4e313cabf8f2f65dc3b09c1be305885b48d1be8b77d40f043"
    sha256 cellar: :any_skip_relocation, ventura:        "b93d6331680e2c44f4a20e67270612f746ec4d37e9d35f5086fac3e4fb4175dd"
    sha256 cellar: :any_skip_relocation, monterey:       "28f547ac6c54b100546ff999fe6b135b18f9239aba4622be480568ad85829000"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5f696916d6c262c5d43f4e1c2ea699b6b71f8b7c0fc6ca8d551ae71fcb1842f"
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