class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.221.tar.gz"
  sha256 "14235f8f692344105a774568179908df9562b337ed15f4be88251a17f36c5386"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b86a1eddef281b4310a81749514a50e6c0de801223f0169ecbc68fa15862de17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90cca4021551c4027b68f97a073bcf34ea417927301b6c258ef55e68b935d43c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad76cfa6f906746172603a9b18d36086f9eede6a2fc2ec0334208ad3ed7dc2fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "454aa34761cc13f39d2dd14b467fd98d0e2d54860dbd1239bc0649f99059d1cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec2a26e7a17d87927f40d074ce20b1f450f819aa37ef91b4c14fbf8297a6d7d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d67cc8810f1250153b903c7f992f5018b41c8306821e731f1f1e372d4875fd14"
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