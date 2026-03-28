class Repeater < Formula
  desc "Flashcard program that uses spaced repetition"
  homepage "https://shaankhosla.github.io/repeater/"
  url "https://ghfast.top/https://github.com/shaankhosla/repeater/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "7d8b10adc4201e59b45981f72879c70d6ff39fbac12583b30b21f4949d904eef"
  license "Apache-2.0"
  head "https://github.com/shaankhosla/repeater.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c81421dd800602c736ed48cf89d5f00db1dda6484803bb7a10dbcb8c2985e271"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91ad9dddab5b224071cd9e6886bf3e29167ec9846145da014ffc38bf95660229"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f76a438246a7aebc4fe63d0fe6ea39d672c929f31bdcd77c3058140ab93a02af"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ffa86d24ac5dbd4c6e57c7e78062226c2008fde13a6dce0bf336fd02c620b2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e73183498a6565543fe697eec2f121bfcf5c2ba1596b8300ceedf23964884f32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f373e82ee626b311bce2ee59f0e20ea2929297f75dd1ee3114c29d8994f17929"
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