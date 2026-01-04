class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.58.18.crate"
  sha256 "03e1689d2a7d847f32fd7ebe741a430782978ccb2b10c1ed0e7812e85cb5135c"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6139fee1b0bea23d88965b3146c3ca5b70c8be81718a565dbce7db23298d4ec9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4dc4162ace590cc9f6e1ed93ef629290548693e33ae00548f6337d0ebee38cd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad55e774f379f38f2ef9f6ff1bfe2d4774a5dc84761320be17c67bae6c8bd934"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f2e372fc6bda2cff184b8ac2c88a082c2be8a3b29dc4940787ac123d759d32c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af3451d02e501a9c537f7c3878f7c5f5dc92bdb9f123425da46787bbf6985c43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03bf48b652b9927d37b41fed06e6e60a5ec1c066fcaec91ba63b887da16f1412"
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