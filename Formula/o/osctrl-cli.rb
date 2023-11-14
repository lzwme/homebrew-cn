class OsctrlCli < Formula
  desc "Fast and efficient osquery management"
  homepage "https://osctrl.net"
  url "https://ghproxy.com/https://github.com/jmpsec/osctrl/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "612c27fffab5f9e1742dd6abc5879dcc11b89966542dde7ee9f88a31249352cb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "494f37ae2466ebcea3f1d331d8210f1a1145453d32987a748f4560ff5d2c5eb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "761bbdbdc5f3a2d5b49f25a70e758cc073d87b91f82603a2c25237b5c545a26e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53cb96f9b2889100d91bb553c2aba7ea614890ea1361f5371047a5f674131308"
    sha256 cellar: :any_skip_relocation, sonoma:         "f39a05e461bc34cc4fc2c5507f135c9e20bd8b7721a4eacc2914822d79026ce0"
    sha256 cellar: :any_skip_relocation, ventura:        "e74f355b6d299fe025fcb650dd41217ac6c89028e19668c77194e1053f941b84"
    sha256 cellar: :any_skip_relocation, monterey:       "3c814a0b3dfbb6c98eafe72897e5485030c9e600ddc3386cef51a28e0a87be09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4ca0c25b6f06d0b142795d891fc65ef8637f65cb8204c6d4ecc0fb6f16cd142"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osctrl-cli --version")

    output = shell_output("#{bin}/osctrl-cli check-db 2>&1", 1)
    assert_match "failed to initialize database", output
  end
end