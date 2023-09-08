class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://ghproxy.com/https://github.com/aquasecurity/tfsec/archive/v1.28.2.tar.gz"
  sha256 "f719f5ffdc90c5d6ac7707339d385b2d4dbeecebc2742a5f2839b44fbf319e27"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb1de2ffc989c75b740d62d234df53a64b5753d8d92c0d151d8fd4534e8bcb71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af6109d8b7fc7cc26551520f2c94791f679df5b56e45007fee807a2336d6ca5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba7c1f47307af18aaa06c232a5178db3d2d4c3f57cbee742a663d3c82029748c"
    sha256 cellar: :any_skip_relocation, ventura:        "c4fcb69b2d1328a71ea3974825c3949678c382b89620120265a971fae520db51"
    sha256 cellar: :any_skip_relocation, monterey:       "1342a0acbb043f54adf3875f0c239afd0f30a65da9b2d064fdf603f86e5a77bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e53ccf3c21f06e2f4d678a8a8fbbd0e8fbd8a1cb136ec3d579aff7d2189562e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fd0f374676b4af0a4caf19794857766830782f1f1d53ebccfc0b5f10e2124c9"
  end

  depends_on "go" => :build

  def install
    system "scripts/install.sh", "v#{version}"
    bin.install "tfsec"
  end

  test do
    (testpath/"good/brew-validate.tf").write <<~EOS
      resource "aws_alb_listener" "my-alb-listener" {
        port     = "443"
        protocol = "HTTPS"
      }
    EOS
    (testpath/"bad/brew-validate.tf").write <<~EOS
      resource "aws_security_group_rule" "world" {
        description = "A security group triggering tfsec AWS006."
        type        = "ingress"
        cidr_blocks = ["0.0.0.0/0"]
      }
    EOS

    good_output = shell_output("#{bin}/tfsec #{testpath}/good")
    assert_match "No problems detected!", good_output
    bad_output = shell_output("#{bin}/tfsec #{testpath}/bad 2>&1", 1)
    assert_match "1 potential problem(s) detected.", bad_output
  end
end