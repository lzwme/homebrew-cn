class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https:aquasecurity.github.iotfseclatest"
  url "https:github.comaquasecuritytfsecarchiverefstagsv1.28.9.tar.gz"
  sha256 "03d61e1419440bcb989c1a2afce3ed32c449bd8b6ea9811532be41c95d676514"
  license "MIT"
  head "https:github.comaquasecuritytfsec.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d812110fbb21b2759af37617b6a74aa9c3dc9966e9f8a9a4d9e2a3194eeded5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea25e8bec86fd055a5283e4506ba8ed7dcfe9a226a5d6277ff71c77d4c03f490"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7787b299c21d8daadac64aa954da0609a6f7f6a41497312d6e4077e4e53ac37"
    sha256 cellar: :any_skip_relocation, sonoma:         "1bcfa86cead869620ed652536e0c05da82c031ae2b3bb298b66dfdec7630f7f0"
    sha256 cellar: :any_skip_relocation, ventura:        "c29d8dda092dc9d6a1632ea99a53b0d959238a839a0db424f87c39f8a73afaa4"
    sha256 cellar: :any_skip_relocation, monterey:       "ba15108b8bdc93178465d4f5533a0e42c7cbb74a25e433bdabb90bec9b5c2465"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecf50feaf41c0c67c27db1ea2128ece368ecedf77fb96d866eb13354bc1d1594"
  end

  depends_on "go" => :build

  def install
    system "scriptsinstall.sh", "v#{version}"
    bin.install "tfsec"
  end

  test do
    (testpath"goodbrew-validate.tf").write <<~EOS
      resource "aws_alb_listener" "my-alb-listener" {
        port     = "443"
        protocol = "HTTPS"
      }
    EOS
    (testpath"badbrew-validate.tf").write <<~EOS
      resource "aws_security_group_rule" "world" {
        description = "A security group triggering tfsec AWS006."
        type        = "ingress"
        cidr_blocks = ["0.0.0.00"]
      }
    EOS

    good_output = shell_output("#{bin}tfsec #{testpath}good")
    assert_match "No problems detected!", good_output
    bad_output = shell_output("#{bin}tfsec #{testpath}bad 2>&1", 1)
    assert_match "1 potential problem(s) detected.", bad_output
  end
end