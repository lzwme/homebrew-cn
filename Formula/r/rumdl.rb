class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.82.tar.gz"
  sha256 "e1753c95494ed35765accead42522ba97c048b77888307559cc42d10fae76e97"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fe93974d5bdbc258a1a0920e9cb2d6fbc2ca93dfb4213a8215e4e2f226275b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94efdc28ddf875846e95fad7b95fe3d91479095e46984aa54ebda512dc3fab6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17bf55b7dbce14dc63c2e2a3f46ae6bce889f0065759837e9c0980e599576299"
    sha256 cellar: :any_skip_relocation, sonoma:        "6273e4725ae35a2b42df5863228de752204c312f461355c28017e7720dca8fb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32261a99934a3e9b12a663332da941fb83cca7f1541b9f7b19e03b0229088eab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5df39957bdfb4d53cb9a482a2e6731a33e6a79e8801d9f91b37836b73cfab371"
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