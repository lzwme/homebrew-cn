class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://ghfast.top/https://github.com/jolars/panache/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "b99c175ad8b818910a009ca33e91d0b1822d9e2e3d7409ebd7d6054f54ae7587"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ac8349834d9c41e03032ba600c245f4b0788142f341e9935de4cc66ed5cb7ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4026547d02c40b44595c3d6d6ce25d75e0a81d83d91f4bb6a4f27cb311eb5f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82e7b93e488d4e9db85ff2444c08d1f8eb53e25bf377a2c917cca6a09caff758"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1af130b5ab8e0c15a0251c055e3494c782560e5c295c5f0effa9924ae43445c"
    sha256 cellar: :any,                 arm64_linux:   "84e449b50bf9fd1e636452146778e256346d62588060b6b3ba2723d2831404ea"
    sha256 cellar: :any,                 x86_64_linux:  "825d972337da5b79fe122a7cc6670339d9aeee3d43f8ae55755bd50bf55970a2"
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