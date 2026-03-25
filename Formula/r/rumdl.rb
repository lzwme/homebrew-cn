class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.59.tar.gz"
  sha256 "71c61ee8af59528bdabb33d9d9cbbb63a168fc3f6794aafe26a81fde9fefe744"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79d8554e29f00e27b77f029e8fddca1558fdc89f95e119d01f8beb9c4aa6abf9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3ebc150cf445f4bfa6834cc91cde3f538f3387b10c85e3e92a58137e235cf68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c56987a4964d35955910aa47d595554ddb813c7daf74e613abaccee8c6839451"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac1489d977d925761fc8ebccf71a0fd175605ca87cca64698ee36a72fa5bfa79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6de2c9eb98c478899f901c0c6ba4af895a2b6663bdc4b2cd248fdc371e3e33ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16a5a206f1936142396335ebdcca995d10cbfc2a022bd03d568a3facc2802bc9"
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