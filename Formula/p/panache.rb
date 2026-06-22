class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://ghfast.top/https://github.com/jolars/panache/archive/refs/tags/v2.57.0.tar.gz"
  sha256 "5b96301d426937bcc1e986eaa0b841f7f9f2e725820f1be254f394a0769265ab"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e686eb462695b7af88212fe872782f32b01a4656760792a60ffb6e926e0d4dc5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30e46efc9a39f7b77e8583b00c07cabc495eeab4c35192f27cddbe89304278b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ee041b4c90c5928eb9ae89a3997647524c7cacb098c98287f44da5eafa7d0e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "6893e46e5362ad6622bcdf5ba26f75e1b08d1855f7fa3de81269a3d8400b031a"
    sha256 cellar: :any,                 arm64_linux:   "a26d2f702c802ad94aa9081aa7e0a3e3fb0b9355d480544c1958788b5012e673"
    sha256 cellar: :any,                 x86_64_linux:  "794ef79a8be0fa46c0d86068e307756cdedb0c13165dab19d711f1f1fe536a3f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input = <<~MARKDOWN
      # Heading

      * one
      * two
    MARKDOWN

    output = pipe_output("#{bin}/panache format -", input)
    assert_match "- one", output
    assert_match "- two", output
  end
end