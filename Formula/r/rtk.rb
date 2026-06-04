class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://ghfast.top/https://github.com/rtk-ai/rtk/archive/refs/tags/v0.42.1.tar.gz"
  sha256 "4560f2f17a392e7ba63d7901a7adb3d93165c3789eee2fe102b914ee8e9eac21"
  license "Apache-2.0"
  head "https://github.com/rtk-ai/rtk.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06c24cff6694c33c04695a195ef781ddef0090013da97dcae4984e73480529dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b3eb5368ae73c5125378b39a16a6e171fd07198390d5dff4be63c8ae7f21a2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14d6c658d2857792e17b40a6ac6bb2d1776c3bd60135b206319728f8c7e2e4d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c41bb501970939384f4ec811f13839f9ce8440bb9c5d6595e08b7d9f53e5aad"
    sha256 cellar: :any,                 arm64_linux:   "c5035a1749ef313328b3f2301eca067c2a547fe19d2e995723e6e7ebf76b9760"
    sha256 cellar: :any,                 x86_64_linux:  "cc3529ee6de89f6bb4517e4e94e06529d958713685b100d1f823388bde72238c"
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