class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://github.com/tenable/terrascan"
  url "https://ghproxy.com/https://github.com/tenable/terrascan/archive/v1.18.2.tar.gz"
  sha256 "365c328e595d7263b3615fcf89b7e8cb7d48353e9a1bac13b08cd5c76a9af6b7"
  license "Apache-2.0"
  head "https://github.com/tenable/terrascan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5bf47133d50134244e04d84afe180a34cab2f5199319744f32d6d36fc1f4a1f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d66c34288a94907e1ad95d4f8149060a57ca5157b4747324ad6a8e537057b839"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e90710f2c40760a3995801f78c5bf482ac2d51ce8430b1a995819f9f1625e01e"
    sha256 cellar: :any_skip_relocation, ventura:        "fe899879bd7dca239f5f045de9ec06e028608a2cfaec3327c9ff326b6509da00"
    sha256 cellar: :any_skip_relocation, monterey:       "b5abd3e4753a84827cdc83a284184a03454c680a7782c4046f97045fb98574eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "421e35dea1ee62de98f49761903b1ce6d2fa8f53855d232df7e1cd591fefe473"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b93be2f8cae2af384058225224c6a941ab3f0ba0930d37ab8bbcf79303215f6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/terrascan"
  end

  test do
    (testpath/"ami.tf").write <<~EOS
      resource "aws_ami" "example" {
        name                = "terraform-example"
        virtualization_type = "hvm"
        root_device_name    = "/dev/xvda"

        ebs_block_device {
          device_name = "/dev/xvda"
          snapshot_id = "snap-xxxxxxxx"
          volume_size = 8
        }
      }
    EOS

    expected = <<~EOS
      \tViolated Policies   :\t0
      \tLow                 :\t0
      \tMedium              :\t0
      \tHigh                :\t0
    EOS

    output = shell_output("#{bin}/terrascan scan -f #{testpath}/ami.tf -t aws")
    assert_match expected, output
    assert_match(/Policies Validated\s+:\s+\d+/, output)
  end
end