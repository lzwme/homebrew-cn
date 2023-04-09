class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://ghproxy.com/https://github.com/railwayapp/cli/archive/refs/tags/v3.0.21.tar.gz"
  sha256 "47e46b46184adb2258c98117dcc1da5fa87beafaac237be92a8be8075e27d7d5"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97f0a23f3d8ea9e4b43448c055f9a654ed8f4693007597b6e5aea1cdf1efa811"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1155b5757b81eed8ac4a8c9381ad9aa3dcf50db0a373b6f1887b8c10b40dcd8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ecf72e027386fc47519c688ffefbdc8a00b614e95229c863d8fb69ff1804600b"
    sha256 cellar: :any_skip_relocation, ventura:        "f801ad500d77db514766d23e31960b137c7f9b0f5ef9ec15693f1fcdb076db37"
    sha256 cellar: :any_skip_relocation, monterey:       "eb11f831c6a0a21bdbe19434afbf2bb0c33d480e28f944fc5ce447984289cbd3"
    sha256 cellar: :any_skip_relocation, big_sur:        "5910f1de3c97137aa169113a65c8b1e6c152e0c9e7b3dbf61049041c4abb4c30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "633fac1506bbb65bc6e9dbf06421e1a81fd3d1102f7d1bac0e9bc57ce1712d2e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Install shell completions
    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1)
    assert_match "Error: Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}/railway --version").chomp
  end
end