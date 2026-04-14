class CloudfoundryCli < Formula
  desc "Official command-line client for Cloud Foundry"
  homepage "https://docs.cloudfoundry.org/cf-cli"
  url "https://ghfast.top/https://github.com/cloudfoundry/cli/archive/refs/tags/v8.18.2.tar.gz"
  sha256 "24cc28199b9f86806e67bdeb812840e4221da2fc283cb120eef726f08a38e3b6"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7aa18ec2058053b495ae9fc08983af2ee30644e54fdbbb100e2ec3cd2d597903"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7aa18ec2058053b495ae9fc08983af2ee30644e54fdbbb100e2ec3cd2d597903"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7aa18ec2058053b495ae9fc08983af2ee30644e54fdbbb100e2ec3cd2d597903"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea4bcc50a95b07de561da7db156f7d24edc957b56e94dff82b00852c245f058e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "710a2e77b245c6cbc3b4d9878a9fca1d5b769bfa712d4a4c68286a45c19f4f6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4310b765917ab7e875247ef32d1768e90e9f7bd297a23e61bee3fa3accff0d42"
  end

  depends_on "go" => :build

  conflicts_with "cf", because: "both install `cf` binaries"

  def install
    ldflags = %W[
      -s -w
      -X code.cloudfoundry.org/cli/v8/version.binaryVersion=#{version}
      -X code.cloudfoundry.org/cli/v8/version.binarySHA=#{tap.user}
      -X code.cloudfoundry.org/cli/v8/version.binaryBuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"cf")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cf --version")

    expected = OS.linux? ? "Request error" : "lookup brew: no such host"
    assert_match expected, shell_output("#{bin}/cf login -a brew 2>&1", 1)
  end
end