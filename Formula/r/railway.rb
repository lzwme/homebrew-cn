class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.15.1.tar.gz"
  sha256 "b58be12e030cd3e4d686ce6be3c62475d3ff6b16fa25b8bb96bd69ed2ecb0bc4"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e49a9284eff08e348de037d010f8bf004377de635a317a08807b8fca0f6614eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b1f697e91b872ebda5347a0714a4f6e19389c49a9a5425b9f2070d13803174f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6883eb9797604475a53d93034a9cb31bed7fc1ddb3be128fe3a90ed659e98367"
    sha256 cellar: :any_skip_relocation, sonoma:        "adb318c5a51702eadb405d380c9994985ac14de1e5649f2f4fc98bc80e0c05eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1112de68f3618ffa06aa52998aa659585072e50ce686904ad734fc357e3ec039"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76e7e57d5986d8d50a9035627c0fd9761d2229ea52af50872f2e780bbfcedaec"
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