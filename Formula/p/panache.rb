class Panache < Formula
  desc "Language server, formatter, and linter for Markdown, Quarto, and R Markdown"
  homepage "https://panache.bz"
  url "https://ghfast.top/https://github.com/jolars/panache/archive/refs/tags/v2.53.0.tar.gz"
  sha256 "950d6a1bdf737e4e56c054baf6da8e1a7a58251062ce8dffa1a7dcd2ce00f06b"
  license "MIT"
  head "https://github.com/jolars/panache.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbf471ceaf2c05c12e378080d575bfa0bba730fa2e5358054a1e85e1dd474421"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a14553e06ec1c38157ea2819f02c729c5180a71c68d74c9b0f1aba633b8e31b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aea7a94638a8773f060697bfe4f4cbb449583b24e2d363686d285d763f570671"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe03d764738a33b690f7b249ef0a40b062eb49e173a9d65d48e346fb93824bc3"
    sha256 cellar: :any,                 arm64_linux:   "a360babd8af7fc8d85a0985711e60d3031be62a2d22f7425dd46ff55abe33253"
    sha256 cellar: :any,                 x86_64_linux:  "1521d7e08ee27380ce7dce36cbb7015e36df76d7ef00edfe43892ac9b38fbb43"
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