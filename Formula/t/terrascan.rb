class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://github.com/tenable/terrascan"
  url "https://ghproxy.com/https://github.com/tenable/terrascan/archive/refs/tags/v1.18.4.tar.gz"
  sha256 "fe8c666c032b8e260fa5d27d563f734469f469d7075a20305f3150507d32bb04"
  license "Apache-2.0"
  head "https://github.com/tenable/terrascan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e425489240e0e34c6f59453fbcf77ca4198071f5671228b12b1de781f4b6e8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5bd3c06bc3473838fc5e43f5651d0f96839c95b8c84b4df5a108759c83dfddb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb52ac12be042019e9fb15797ceeec6a5fc68664697585e7915621ba2bd6ea2b"
    sha256 cellar: :any_skip_relocation, sonoma:         "d890b8047a59fe080c84776dc166e43840fa31dd654675cd7613d7bd1c090251"
    sha256 cellar: :any_skip_relocation, ventura:        "de1f6a4f53e16d649bf9fc4e19d1e0361d9a54f689c3cdee11ab8c37dd10f6a8"
    sha256 cellar: :any_skip_relocation, monterey:       "d4189cbbd28b5cc847e977c31ba5cf1366f4f2b0046f1eed440a35b2323e8b09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acbdef2de69378262bb60a8908197a41b767a8631bd5bb157adf57a4ee032e8f"
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