class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.60.tar.gz"
  sha256 "a5339ace0a8c6519c7a464abf59074fea99c5ea2eb978241d49f5c78698e135a"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eecd52d04900215a93a27769fd5e8e962ad13c6716219bba77ae5d0cb01144aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "141a507d08f528e85bae769655266e98ad7759545e0b6288732c312b7076a0e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51a8f0f75d7dac0593177260d46e3dc52cf39b855b0119b9b6c088e2e4f6e7dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0c542ef313064be0a020038425c43418c125111e9edf3ab195c5817419e66d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fde3d642fb893e563d4151188280511e6aec194b0980f31ee99ae8cc06a2ca09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6f32857eaa5dca64746ae2142005662a1def606fcd4a0871e1c138cbc873173"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"rumdl", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rumdl version")

    (testpath/"test-bad.md").write <<~MARKDOWN
      # Header 1
      body
    MARKDOWN
    (testpath/"test-good.md").write <<~MARKDOWN
      # Header 1

      body
    MARKDOWN

    assert_match "Success", shell_output("#{bin}/rumdl check test-good.md")
    assert_match "MD022", shell_output("#{bin}/rumdl check test-bad.md 2>&1", 1)
    assert_match "Fixed", shell_output("#{bin}/rumdl fmt test-bad.md")
    assert_equal (testpath/"test-good.md").read, (testpath/"test-bad.md").read
  end
end