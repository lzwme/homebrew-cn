class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.61.1.tar.gz"
  sha256 "65392c6ed012c5da6b18432e57b9a6a93b2db16c06c29d932894d4ff79ca6c2b"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce8b3ce454df11fc36652dd01fef1e97fd353f685669b9bec6edd6418b8ec644"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eca0680f19fb123f057b449766d93df9a82cc9f649d9c6008c95d4d85accdb70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ae88f6dbf4dce14efc7d03340e703ed9952be7e153694cbb1eb29216254b02d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d90f206e0d4c826703ce09852ae951e8c9d90c95393ce723f48e9d1c4d927f90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa23a6b5689f939f3baceee49789aa1fc079cda6aecc8ad13f8126409ff2b50c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ee9a2aa73ec6c1d31918dda4d0dc9ea4a9495b470a0bbdf7b4105a244bb305b"
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