class Harsh < Formula
  desc "Habit tracking for geeks"
  homepage "https://github.com/wakatara/harsh"
  url "https://ghfast.top/https://github.com/wakatara/harsh/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "da8c906453b08e7326e267d97c3110761fc4795c85e955f6993bad76318f7665"
  license "MIT"
  head "https://github.com/wakatara/harsh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db3871f7e241d9d8abc71d0aadd1f71ffe30c9c70eaded3131bcd0276abf13d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db3871f7e241d9d8abc71d0aadd1f71ffe30c9c70eaded3131bcd0276abf13d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db3871f7e241d9d8abc71d0aadd1f71ffe30c9c70eaded3131bcd0276abf13d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd106e3a27139f00e06adf74d09a187c4f0d33db1f89c8169565448814bea78e"
    sha256 cellar: :any_skip_relocation, ventura:       "bd106e3a27139f00e06adf74d09a187c4f0d33db1f89c8169565448814bea78e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21ef18032cc37839fb6b371a6986a31846b210bac715f160df4aa2bf5e6bed27"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/harsh --version")
    assert_match "Welcome to harsh!", shell_output("#{bin}/harsh todo")
  end
end