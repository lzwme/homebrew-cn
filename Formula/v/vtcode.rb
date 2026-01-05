class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.58.22.crate"
  sha256 "1909445325856c4d55997e7abcfa94c3781be3ada5b2ea07b5ba2fc870760bba"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "787ca329eaf6424f76817fd0b62f8bf91b557a0d8238f3d1019b774fb28208b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44c06ae015ba82ffbcc2d301f62b2d076facc8c10fdca628c383edcb8a22fe66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ed859b673850419f9aa50ee6e17cc586d77b84a5828b885b83d7ff2a160bc58"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f85b7db118f76bdafadc08f2a53708b53fb54d75518d94fca3084f2b7108869"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab740ef7d0c44c83e50be7f9ec57794049d1e1ba84f3aa37fbdf205da71edc98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc7c0a217cd0a13fe83865660c100d51e88e08e4e7df32900442a649fd142d83"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    output = shell_output("#{bin}/vtcode init 2>&1", 1)
    assert_match "No API key found for OpenAI provider", output
  end
end