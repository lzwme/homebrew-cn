class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.42.0.tar.gz"
  sha256 "890066fe73a471084a9f0f83366aa88c76391ec8f3a2259979dfa50586a26f2c"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f802b007b50d7380a724c115e619277f27eb385ea02bbc01643378ab5fd1c63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5db005dab7394f3cbd0103220947272f3111f74332a8d1423c2fc1df98f35117"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7dc560c2c4a219d13a3de0c612954efe4adb7cba08739587ef17de22448c630e"
    sha256 cellar: :any_skip_relocation, sonoma:        "61d112cc54d2a280c2e490febe1978b5880cb23a969b72ab86bfafb835ed04ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9762e3ac3ce0b452962d5aea5d72d43860ce949cba18002df95d5da66f128d40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58a249c00d666e0daec96cc8d2cffced43f7e81d3c5459b1ad5a16a699d27878"
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