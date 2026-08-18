class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.41.3.tar.gz"
  sha256 "287b720eae69bc45365bf3428ff87e03439f0ee2a80052c2169946f8196c95f3"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7137a8e6a7f71b9d528e01281f7c9733f7eb4ac5087c336a4079b33a243a6d6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bcdfe71cfe8e578be2267874f678acf6b52d07c6ee1fe15e08627228741f9b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d21bde9492d6874945df3ba9ed842c336d36c0d6eaedcd23bcedcf48e0057f8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9478707dcad99345b4cc6b6cb1c3abf3617cb7bebc5b3e32b110ada53adc47cf"
    sha256 cellar: :any,                 arm64_linux:   "33b336d03ce241d30f1f8d33c1e5ba3e020b10fa12caed07955ad941039349cd"
    sha256 cellar: :any,                 x86_64_linux:  "1947d4fa51c6ba9c5fbb8e079ad275800487c60a15e8ddba25caa36dc6ba36fb"
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