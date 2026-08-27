class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://ghfast.top/https://github.com/rtk-ai/rtk/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "6f263143f654486252bb8075f7464d82ebc8adfec7f2995d57e488b928fad695"
  license "Apache-2.0"
  head "https://github.com/rtk-ai/rtk.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d5c60b9b57f280692a4e99dbb65fe6ebf9ec5edca5e4d01522dcf1dda639899"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "179ac71d882f28d216476ba5553391e69e804223225ef3d79749f984fc794864"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e46e431eac6682b60b1bbf7721dd6f645de238d8e757f3ed13b50d3eee613258"
    sha256 cellar: :any_skip_relocation, sonoma:        "3140cdd595314c498b64c44b54268a81a513022b3403f02f214ed29fa7574771"
    sha256 cellar: :any,                 arm64_linux:   "fb711b276ff21a2ea83139e0f31a3eea164955fca249faf685bfda828dddd1cb"
    sha256 cellar: :any,                 x86_64_linux:  "b8cb6d436314f0ea43f3a4e6b51d860b5c3c9696adc24f12d4a2eef101ce5fae"
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