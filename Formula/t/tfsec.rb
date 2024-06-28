class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https:aquasecurity.github.iotfseclatest"
  url "https:github.comaquasecuritytfsecarchiverefstagsv1.28.7.tar.gz"
  sha256 "eb25ba57c37a8baad985c81ed2abf0d537838b54c3135a953d28fa11a3f5dfc4"
  license "MIT"
  head "https:github.comaquasecuritytfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "49bce7be78318f5e2b9b98a4882ddda804f3d60879942c35554ea19bf20d143d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "046a573c436fe507e66fb785fa1fb96c6b4bda1f61abd8d5e12556807a16f83b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "024e99c1efb07451e1b506f68c5b6430989110f5a735fc904d859f98428d516b"
    sha256 cellar: :any_skip_relocation, sonoma:         "508600ea5381b5e876e1819a6e060bcbb0bb8df91761f945772dd2cb3f2ba20d"
    sha256 cellar: :any_skip_relocation, ventura:        "498c8b45bcc0021b8154e0c8f938b53f9c2e01b7c1afb5ce6c5eddef2085090e"
    sha256 cellar: :any_skip_relocation, monterey:       "1e0595abe4d66306c01e9a93bdf6a4b9b2793cd55185a14808aac5d0b91f3eff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06ff2073b9c5323693e5a21dedf0cf4b7e039e24a74ffb004014e9973bc2fa62"
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