class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://ghfast.top/https://github.com/rtk-ai/rtk/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "6f9f9466f0b5663234ed0ff3593ca8adeece19bd1472c6579349acfa4680b992"
  license "MIT"
  head "https://github.com/rtk-ai/rtk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "929746f802d065a5a825e199d37e6de9c460d5e5c21de8dcf35e670ac2275a4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c998cf562ede68a639d98fbaa4a8d9eef6414323a927c8d29eda7663dac19281"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2c30b15bf482f332f42002b97bb90a42f69daedde4a96b2e8a6d9fcae36e006"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6e1cd2345bf16b692e170c2a41b39bf07758705ff31ba3f7964aab9c868425b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e4bce1b883a9129cf15989308abbf647bbb2cd5f4c79b69826d1a5a6dcea005"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53a4647201ffbe94d28734083a866a438db88e28858d2f4645506d8e3bd0f46a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rtk --version")

    (testpath/"homebrew.txt").write "hello from homebrew\n"
    output = shell_output("#{bin}/rtk ls #{testpath}")
    assert_match "homebrew.txt", output
  end
end