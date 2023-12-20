class Presenterm < Formula
  desc "Terminal slideshow tool"
  homepage "https:github.commfontaninipresenterm"
  url "https:github.commfontaninipresentermarchiverefstagsv0.4.0.tar.gz"
  sha256 "5f82d523d41e4259dc69cdd74ca37bcd93e329980e289f7aed06214bc6f2fb0f"
  license "BSD-2-Clause"
  head "https:github.commfontaninipresenterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f341aa8252c5519e91b149e90ffbd423d03f923b1a149b04345313fb02fae511"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4128aa258b716a1b0adca1414dad37519b5fd52c41ae8d5976bc66b92c393143"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fa02e2714242400a89c69ed13a96f34dd418af735cb11c3d52861871b778e71"
    sha256 cellar: :any_skip_relocation, sonoma:         "c0fc590df2496365a07b0c50347443c68e64ec2065ce072fb073fbbd5c237456"
    sha256 cellar: :any_skip_relocation, ventura:        "5d8debaab2e62b7d969ec5d21d9a5b879816c8c6581758e3f5668ee5ae99e7f0"
    sha256 cellar: :any_skip_relocation, monterey:       "6ecaca0426470f830c80e7b2a7fc0779fd7ed264e520c1165b36902b349810e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "516df8f929316d69c95be022b09f543063d1d2dbe07cdf2242f583b52f2971f7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}presenterm non_exist.md 2>&1", 1)
    assert_match "reading presentation: No such file or directory", output

    assert_match version.to_s, shell_output("#{bin}presenterm --version")
  end
end