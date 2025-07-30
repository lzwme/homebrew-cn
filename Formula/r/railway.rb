class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.5.6.tar.gz"
  sha256 "b1df866de7feee582c2c12c85718af068f14c8b744f544a75c600c79ede85576"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8542f04a00a4e9f36784a893e76a5e1b2446c4db4b919c51ce22e3c89be6cb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3230bcfd7f607df96b4f627cfffc665dac0332102d095c8a57be41950ac9265f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "890657b322a679ecafe9eecf08ae62418b70ca67000b0bc03821761132906470"
    sha256 cellar: :any_skip_relocation, sonoma:        "451c58f6b091985f47fefb7ab4ea07c5a1be1a25245853a277b14574ecd1da4e"
    sha256 cellar: :any_skip_relocation, ventura:       "3d2bd37d7a94f582f761d09b30d5d57887a1fff25f521714203c1113a524e1b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdf1e80a18da92afea968dc418a811b149bcc1749b9f0328fc7b8ad47fdd3809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf24654a390302c2c52e2335094fbee1cf2d6811b40d146f61f9801cf9cd06e9"
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