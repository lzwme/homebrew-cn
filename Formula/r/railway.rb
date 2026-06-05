class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "dca60a7d04bd2a83af404f765a91026f94747d35f305c00f64e4b5308f831f38"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67286f09691825e8f75a924db0da8abbce309f714bf3067d07dfd984532fbe1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "676c3161867bf1d38636edfbe1b6eb6aefdbce169ef0579910d5f29970568462"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "496d04b855783b0e6442022fe5a8dbe595f7f7da438c9c90e8628a2fbb68bcc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "92c37afdce72006f64524fe196964617589055dadc3fef22f0e1298f10ff886b"
    sha256 cellar: :any,                 arm64_linux:   "212ac081e60c3882fedae1aa7ebdad06f97f097fb681e51dbec962bc3ec30704"
    sha256 cellar: :any,                 x86_64_linux:  "85f2a0de5c16333e5e16c0a42ba5858856c0eee42919c0085f24bb803808bef1"
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