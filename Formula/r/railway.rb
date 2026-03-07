class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.31.0.tar.gz"
  sha256 "9cc5aa4328fc970568efe6fd256fd0c5da46f9daacfccd6837bb4047ca06bde0"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "377b21b8d3480c6189fb7db06d78b3fe94bb3355c7596b90922981c20c7a1cf9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05e592f2259af41af90ef90da27cfa18d4e77fc3027beaf5280517c07f7e375c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d6636c7f48410daff88f19f04925fb12e622c8079ac7154c51241ea119f30d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "631210f208f2f883c4b5218bea863a4ed6a043d0e969a7c4947d4d1c4090fe3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c323adc9a9cb627bec77d32767a7fba312abe0ae9bab3171400b7f5f6eb71ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d3d4f5a1cd59a216dc26527aba330c59a518fd91800e4296f38c9a6effb503a"
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