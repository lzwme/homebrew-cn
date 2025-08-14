class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.6.3.tar.gz"
  sha256 "3ac8fc532131e53dfc2f2c71717c6d676391409e580b8a9173865a2ebb019c59"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "582039f29da9a39d1d5fc8bbb1df6ef412f5facedf819b1146ed944354b49cf2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "484da38f9b741bd0655b39747e42b01e3d145fc5d8f1836fec064a45287eb482"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c7c76929a5ebeb767452909d654a9bf78f225262a3987317747324968965226"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cba5524d063e9ad115a6b6fa7096c34e1446ff64a63328fdc9448d2d9259cdd"
    sha256 cellar: :any_skip_relocation, ventura:       "6c8a24fe7d7a33f8127d8e3f93d6e2d9c8d2f1ad7b1efc48e5cc76aa1741034e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d729d5e90ac280ceaadfa2659cd1dfed925abc8008ce1ed0d2c7a5f110d0cf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c06c3c7989730f1aaac072f6a7f6bab1ca5b298d985a473fd8569e3d80ef8d2f"
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