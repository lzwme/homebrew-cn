class Mactop < Formula
  desc "Apple Silicon Monitor Top written in Go Lang"
  homepage "https://github.com/metaspartan/mactop"
  url "https://ghfast.top/https://github.com/metaspartan/mactop/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "ebffe76bd1eae4cbc1071c7c37ea5f3f667caadc1a706bcef2af6511d6e1b284"
  license "MIT"
  head "https://github.com/metaspartan/mactop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27767f55be2df79df6ff6268b57a05820f88e5b7124ede1c5574e1118ea7bdef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dedadb5538cc6fe7b3a7888cf2c75025a36b69cbb7afaef2fc5df8705d49aa86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "581471d6a294e75932ac3920ff2f748ce5242d8098c596f07c966eb6fb8b545f"
  end

  depends_on "go" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    test_input = "This is a test input for brew"
    assert_match "Test input received: #{test_input}", shell_output("#{bin}/mactop --test '#{test_input}'")
  end
end