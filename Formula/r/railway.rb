class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.49.1.tar.gz"
  sha256 "3f8798d4985cc89e970804c71f8a4ff4402da54efa84bba04da3dff1b5f7c6b7"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbb0c66612d3041118431ac930de739d347766cd528d6adb4c52983ac0e97dec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b471f39d55574225fc656f4e1ef4a0022950d0fc6f35bfa792c4efb7fee77078"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8c3f63e684d888f53c6025e195cd51870015d7c25ab38c4ba70e773e17c4666"
    sha256 cellar: :any,                 arm64_linux:   "4e00bac84b6afcefd385c4dbda090f33e9dee9f2c8e2f0dac03d273b6b545b40"
    sha256 cellar: :any,                 x86_64_linux:  "520b8c36b45b8962603f140a5705c6d7ab16569169a9aed7e13cd1aa38b8dcc3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end