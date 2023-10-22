class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://ghproxy.com/https://github.com/railwayapp/cli/archive/refs/tags/v3.5.1.tar.gz"
  sha256 "3e802c369d88e6008a0e9922ac1723eb7cbdc12d8d02e93f2af34a69af80dba5"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1474e7df8cb3f421b89688361ddb4d2cc1a53dec033c227205cd9505edf854a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97b3217787c7e90b6c2ce0d9ba0201fa3f6fc7fc89e0a142b0b30728b5e62f8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25628cb893c8fd20798070ff4dc9ad9f2924abc6f6ce123016b7b463155523d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb7f61218eb12075ff192cf4dd51b9d191fcd902dd317d0f88bffa4f0d6accde"
    sha256 cellar: :any_skip_relocation, ventura:        "79759ec6cc7e4cdd897f61db273f4456cfa1f823565668c0d7fb08cb2deb0abd"
    sha256 cellar: :any_skip_relocation, monterey:       "de3531f75947585e2a1fc3feb8baad1b1ca5b6c10f56420b9dc397751d4aa675"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3ed14078513ea87b718e06ac9c2f8b421b18464eaaa4518f521b839d52103a8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Install shell completions
    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}/railway --version").chomp
  end
end