class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.50.12.crate"
  sha256 "64290a97f3c2e712a5ababf9ecbe0d615b698518c4389fbe0545401f7071daa9"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "991773b630c479af2afa30ffef9aee171e00d45f6727685a9e1560ba9b58d47a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94ec1c642ff6a03dbf6a78196dd87a4478b31d473c0b014e06a6d11482702356"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76ea8fb3b6c68fddad48d112244931e1ac81eb5193b34e4c03962805c101fa33"
    sha256 cellar: :any_skip_relocation, sonoma:        "34f2183718d4c0e286145345fff99f7dffffb6bc8e384a6eba5c30baeb89dc65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df7775c024c4b2ab356044ac1d582527eefb3dd34ff7d381f3af4655e0f517c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36165dd82efb3d9e2a3ab1662287f5f75b671aad471034903c24b3b949fc5173"
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