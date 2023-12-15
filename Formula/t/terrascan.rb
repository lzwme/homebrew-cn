class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://github.com/tenable/terrascan"
  url "https://ghproxy.com/https://github.com/tenable/terrascan/archive/refs/tags/v1.18.8.tar.gz"
  sha256 "45b1418e63a791886a5412af47b9173a618650e066a753540e74819532f22055"
  license "Apache-2.0"
  head "https://github.com/tenable/terrascan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c58944f526b2adc0f98a0ac50066ac72e4ef1c1a3b16523210bd1ca1e6fc889c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97afaece7fcd8d85d9d3f2d70e9ad4ec1922ca7344daa997abe76d3eaa475de5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9806c8b85ec0a4d4c73c5ddeb06436f064cca629b29c215bec1d3f907a890da1"
    sha256 cellar: :any_skip_relocation, sonoma:         "88aea10774712628d299a41dea80c95a96662f8f8eb37c372e9f2765940c6869"
    sha256 cellar: :any_skip_relocation, ventura:        "8456ae4bfcf5cd8df3a774f49dba645119ca325d5ec848f6bb03321510e8d9a0"
    sha256 cellar: :any_skip_relocation, monterey:       "d90ed1bcf938c8bb88bdcb2a9e52edde84d8d63ae40551551d33c0eef8b57ea7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b273ea752d0ac8f4f12504c20f7d6e23a5142f66dfb0eaba57820ef9e3779de0"
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