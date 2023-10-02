class Ghr < Formula
  desc "Upload multiple artifacts to GitHub Release in parallel"
  homepage "https://tcnksm.github.io/ghr"
  url "https://ghproxy.com/https://github.com/tcnksm/ghr/archive/v0.16.0.tar.gz"
  sha256 "c2b1f0a25b3e0b9016418c125441f16615387e32bce5c56049064deffbe1b1c9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "50b5eddd0e7beb7505709da8ae8238050c851cc32bb59fd82e622266e1ce56ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aaf361b786efae90b48964bc56fd935412c4db14303dd4bdca230331f285fd5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aff88f794b79ecc4412ba3f56c3ec835c1ee4d620b2948b918b2d07cc35c18e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52233c065fddeca71a3932cda06c6fc6737675f42f6e9cec325834ba3a1f1d7a"
    sha256 cellar: :any_skip_relocation, sonoma:         "526ed850fd034f7a5db5dd2c41e8239e17f192b278e94fefd4fbc83031fe45d2"
    sha256 cellar: :any_skip_relocation, ventura:        "33393c84870f74c92acdaec6294bf5d49a555b354d249d54b8376c23645020b2"
    sha256 cellar: :any_skip_relocation, monterey:       "d6900cd810ced4aa78c721505833f3b4d06fc75c004c555044c2ed2bd6098063"
    sha256 cellar: :any_skip_relocation, big_sur:        "71c80121c792b3f62ac50215adfec225022c9f79cc902493792a87e7bcc81c45"
    sha256 cellar: :any_skip_relocation, catalina:       "b7ad64d380266fa300f33cfb884e40090556065e2b9c59eede706543eac24113"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f84d33e3ac1358c3a5a36d7d8af0e7ce5990cd1a816de97e304320498a1b38e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["GITHUB_TOKEN"] = nil
    args = "-username testbot -repository #{testpath} v#{version} #{Dir.pwd}"
    assert_includes "token not found", shell_output("#{bin}/ghr #{args}", 15)
  end
end