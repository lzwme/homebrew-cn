class Repeater < Formula
  desc "Flashcard program that uses spaced repetition"
  homepage "https://shaankhosla.github.io/repeater/"
  url "https://ghfast.top/https://github.com/shaankhosla/repeater/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "26b26e6430460c93e6fc73eb72de1fb8796d2c0b756d29ea59970b433165f149"
  license "Apache-2.0"
  head "https://github.com/shaankhosla/repeater.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "249d3021464bce8e8368ba463f8d40c2e35624344603442b80965d19b4929873"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdb55b6ab5cf452227a10310fb709683195057991db1af3330d7c0e9eb2b3b84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5327b0d43f1924a862122fc10975e17609813317ff927e2d54907684628c2c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "96d442b5b48353d8bdf539a043b5d38ee6b05908d1cc53b34727fce11cfaa4bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "101e8ddc33133eb3f29c25010a05279e0481c2ea7c641f91ec3c59eb22564f29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59129d44b907ed31b457f2daf140b25bc5aa2eec1861bf3efb79ed2a5a766828"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/repeater --version")

    ENV["OPENAI_API_KEY"] = "Homebrew"
    assert_match "Incorrect API key provided", shell_output("#{bin}/repeater llm --test 2>&1", 1)
  end
end