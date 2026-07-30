class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.46.tar.gz"
  sha256 "8231af054062b4a9a3652725bdfcf1e26f82a214917a428d41b998acdfdf98e5"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ac25671344592b80f47698950f76200da5f780ac879c8d2b9807ed0f051af47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ec8b3fe4f52dfbce7792c0324e6718e523748a22dc45fc625ef69d44a2a452c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "beb203c982bf7ed28a7c0a8aafde536482c857fa649aa577b6c074337f707e77"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f9620de51ba9be32d292ec6ca03d36b84ecd8b0fc9a9831f2e7edbddc507c13"
    sha256 cellar: :any,                 arm64_linux:   "a0ff19ddcae139d01d6b6a656ba428cc8a5be71183b31ebf507827c7bca2e518"
    sha256 cellar: :any,                 x86_64_linux:  "18ff9f434a3c64723690e4869485581977c8fc0f3b3f68bb1289102f18740c7a"
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