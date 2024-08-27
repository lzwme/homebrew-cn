class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https:runterrascan.io"
  url "https:github.comtenableterrascanarchiverefstagsv1.19.3.tar.gz"
  sha256 "426c37bfc70996b80cd708bd473ec46673c47ed4a6ad8bf1bc5355a53170d461"
  license "Apache-2.0"
  head "https:github.comtenableterrascan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "37253ef3f12ce16d4ce7ecc1a5d86816764a553992e3af454c8a978737fe6216"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "266099d7586400962e11dff7e25523c3f01e007cc76fda855633ef840e03ae47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa9e1fca9c1e9afe9ac5e05bc0e8a7d416a7a17e597effd19f7f88982d6e1a31"
    sha256 cellar: :any_skip_relocation, sonoma:         "5295a9f6250958e829e68b8674aa9e4e628b6254a8469dce5dd676dadd5a09e3"
    sha256 cellar: :any_skip_relocation, ventura:        "13481a79824311fc33cbc679100df60180f336310f19fcf30ac0a272f186b324"
    sha256 cellar: :any_skip_relocation, monterey:       "834621abc71598233c2072736e1a07f12279d0b80599c9f072dd980effa297ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "894012e79d326e78e425c052d985cfaf90d14bb0faf44808d0e6349b6a4d2130"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdterrascan"
  end

  test do
    (testpath"ami.tf").write <<~EOS
      resource "aws_ami" "example" {
        name                = "terraform-example"
        virtualization_type = "hvm"
        root_device_name    = "devxvda"

        ebs_block_device {
          device_name = "devxvda"
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

    output = shell_output("#{bin}terrascan scan -f #{testpath}ami.tf -t aws")
    assert_match expected, output
    assert_match(Policies Validated\s+:\s+\d+, output)
  end
end