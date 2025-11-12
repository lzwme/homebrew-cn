class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.43.5.crate"
  sha256 "50d02fb3a3d6010cbe71033a5216e9113d67317ae1e818fab9eb6f4221329599"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3dd4fae91f715f09804ce8e700b3655920a4557a2f6dc0ef3b8fe833b8e16073"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49a5da6f717947870a0c5d787cc76cb039ac7b3393eeabac1248109e28318a4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b9723bb5bf372411acdce302b37db10f2276359763c917d6a9267af6fe2178d"
    sha256 cellar: :any_skip_relocation, sonoma:        "838e8258d6d4df273be8b7f445d16155cf037310e6e045693e7d7af199d611c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6ea507b5909ee9ae679202e0585cf462dcbdc4df85429ed979256586d0c9063"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c212def42ba524b9b07dec2c699c1eb362059b329083cbc5ee732e9b044e2fc3"
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