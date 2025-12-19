class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.195.tar.gz"
  sha256 "d9364341a93b0764623b649eed1a6c137df3e0fdb2342f845d6ba02e5c7ba181"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14f6fde57674dbfb31659282493d39431570486a025faf2cec97cbe5ad24b1fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c23af52e73184b11d1863ee0f221e3eb3ee5b884f0131fa7997dbfef966213ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76e654351dc2fcc6c7abaea0cf2113f9380c443a4247eb22f155ea86182d9bab"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb4933819d45359713efb8ebfa825888e9afe4f5a9f0095d56effa05f9b4defb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b963329dd77f8604d51069fa33872aa0fe1d07a95261df4301e3298ae6995612"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c080a69861f5264b6202e44b49bce599204f1588899250d1db1a88c0822d106c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
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