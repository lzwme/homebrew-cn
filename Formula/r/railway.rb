class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.18.0.tar.gz"
  sha256 "cfa4eec0497cb4a41d80d5741abc09fec57ff547a034292771b808cb4842da19"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3627846e12a4bc9989e8ccccbe9eb7f9c1d4da94bf98bbb06c2cd14497508722"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "426350d45210b499577a187a68efad50e0bb9cc290959890e3559131137de98e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e4ce536f67cb7d69c4cd76da4bc51799ae76ce876fb121dd0f7493903fe9bff"
    sha256 cellar: :any_skip_relocation, sonoma:        "1195ba679be552bad83739ab816589a7a295869d019b659c0711c0999c76aea5"
    sha256 cellar: :any,                 arm64_linux:   "9619a95dac6fbe6cc377706fb6ce5449b00515e36bd3bb3467a4a89ee901e5f8"
    sha256 cellar: :any,                 x86_64_linux:  "f11008c588ec7848e6136dd114bbab4a883ed401cd66161b736707541224b749"
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