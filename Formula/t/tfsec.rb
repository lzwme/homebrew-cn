class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https:aquasecurity.github.iotfseclatest"
  url "https:github.comaquasecuritytfsecarchiverefstagsv1.28.12.tar.gz"
  sha256 "724e2ba561c63e6e4f1303481bd06a6a8c8c11072a166932de0bf430c043ff25"
  license "MIT"
  head "https:github.comaquasecuritytfsec.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "497d0e98ec60cc6da31f71f8d1bb9462561904ed3aad025478db4332202be9b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf207d17b86637250ee0693587321ee59bc3f0438cf189fd414bf1e8ee50e983"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0912bb73c809b6cc3d626183e02f04c3a83ab9b311e8ef291eb12582e15ce331"
    sha256 cellar: :any_skip_relocation, sonoma:        "4665f8b946d141a03f50cce4f4ec02bf7e94f9c48cc8e572356c5d7ec04dc8aa"
    sha256 cellar: :any_skip_relocation, ventura:       "fca58e195abf6c6853a07191b40893cfd71c145409f48fd74dd10dd820c886de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a89c592d9c262d0e31330b1c81a1021af11d0e145068e7bb6098f2f37f999a83"
  end

  depends_on "go" => :build

  def install
    system "scriptsinstall.sh", "v#{version}"
    bin.install "tfsec"
  end

  test do
    (testpath"goodbrew-validate.tf").write <<~HCL
      resource "aws_alb_listener" "my-alb-listener" {
        port     = "443"
        protocol = "HTTPS"
      }
    HCL
    (testpath"badbrew-validate.tf").write <<~HCL
      resource "aws_security_group_rule" "world" {
        description = "A security group triggering tfsec AWS006."
        type        = "ingress"
        cidr_blocks = ["0.0.0.00"]
      }
    HCL

    good_output = shell_output("#{bin}tfsec #{testpath}good")
    assert_match "No problems detected!", good_output
    bad_output = shell_output("#{bin}tfsec #{testpath}bad 2>&1", 1)
    assert_match "1 potential problem(s) detected.", bad_output
  end
end