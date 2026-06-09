class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://ghfast.top/https://github.com/alexpasmantier/television/archive/refs/tags/0.15.8.tar.gz"
  sha256 "7c433b57287deba6c02b7722a363b854f1882439628567fa9adcae84fa95e62c"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b57e208c355f819d149bc33365e0b42a3ae20306ab789bfa13d1b46a9d1497c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9e734a6a7ced12082e5832571db61084576341864eca16b4cf018d05ecb4de5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a10fba403f7481d71c1c18cef6ba5d2f6724684f9df7143f55e33bfd597b90d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "84d08d8bd710781d382dd28862ae0176705d4e93cc5505f8f5980bf77afe21ac"
    sha256 cellar: :any,                 arm64_linux:   "168650415b3baf0931ed0c0e7719da4b5f7a5e816258e349e0daf02a334d03ad"
    sha256 cellar: :any,                 x86_64_linux:  "b1f901ce1c3866d44d78cd634c346ca7e4af154366ecfbdf62dba94b5bbb5d70"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/tv.1"

    generate_completions_from_executable(bin/"tv", "init")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tv -V")

    output = shell_output("#{bin}/tv help")
    assert_match "fuzzy finder for the terminal", output
  end
end