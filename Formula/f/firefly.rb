class Firefly < Formula
  desc "Create and manage the Hyperledger FireFly stack for blockchain interaction"
  homepage "https:hyperledger.github.iofireflylatest"
  url "https:github.comhyperledgerfirefly-cliarchiverefstagsv1.3.1.tar.gz"
  sha256 "d2b0420b37c1ce6195e0739b2341502e65fea23c3ddd41cd55159ea237e01f23"
  license "Apache-2.0"
  head "https:github.comhyperledgerfirefly-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4aa882c225163110ccf449a1a35b324724cc6cfd11a1f671cd437329688a18f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e777e7aac58c177aad15d9e3f174c5aaced3a6f1ea31099991eca326b47f2cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2024d3903e2a956ece3d20aef8c6b806829ffac3c02f261d1d0ed1ceb67cdcdd"
    sha256 cellar: :any_skip_relocation, sonoma:         "18d5aee81d0e4941a66805680fc0d397a958029d9979586fa73428202a76c281"
    sha256 cellar: :any_skip_relocation, ventura:        "c393d7ffe35d00d3c267908e3a4511c7189d3ffe2578cafe816db42a9c7f32e1"
    sha256 cellar: :any_skip_relocation, monterey:       "91cc49ed362308ae1f6a691588f174aabcbeac6a92c9f9690d0428ed65ebf55d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19c7752cc7b75887c29cd5e153340c0ee8bf984ba6c04ca6ec3a12b583f62f34"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.comhyperledgerfirefly-clicmd.BuildDate=#{Time.now.utc.iso8601}
      -X github.comhyperledgerfirefly-clicmd.BuildCommit=#{tap.user}
      -X github.comhyperledgerfirefly-clicmd.BuildVersionOverride=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "ffmain.go"

    generate_completions_from_executable(bin"firefly", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}firefly version --short")
    assert_match "Error: an error occurred while running docker", shell_output("#{bin}firefly start mock 2>&1", 1)
  end
end