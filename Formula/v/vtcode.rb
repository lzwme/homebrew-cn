class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.40.1.crate"
  sha256 "af27c58d87b8514e28b53b796a785b0852d549293897084f24d79e4fa7ce0219"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe906b23a45fbb28add3873f3a66cd5e591452f804fe20c72c1184ebc68fbe44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ebd0b4684f55e67c995192d8fdd384535e475dfbd65e377a1719ad7b213a70c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd7a04fd14ce76fee5e4936354de50a64732dc256afe2b9f6bb18519374febe8"
    sha256 cellar: :any_skip_relocation, sonoma:        "493b6bcf9f12cbc57e9658014f91e5986359851a790bc1e3304e914ba473db1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12b51242129ae34844c387fcca702613943323d981bf4eabbd55f1c6f9fcc93c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75d9ba4a488d187e317ed232345000a23acea246686cbfa75ecbb4f56b58362e"
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