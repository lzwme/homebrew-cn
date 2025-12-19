class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.50.5.crate"
  sha256 "81d37459439d64916c51107e4cae4d328a74e9c66811bd8088660f3afe0c9712"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "317e80bc3d7868cbd9b10e7dfc95c89856f89c2ef0a8b6185855d6b6c7c970d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce7d0a4cf2f40657ff16c0dbdf05d9dbe47820b33920390e5f495ef8d395d8c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcd0f57dd8ac2ae583ff32ed9412bb80606056b48bd02681b202337b61d8cb9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a810b4d108c8476040e1dc2979eb1d4eff5391e0aba6e820ac063dd583c968c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4135e7eea5e265c98f74f71be5cc34e1d0c28a7ce8de88f05bd65815afea004"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "575ee19e099f296201a2ed130c265ba6f463696e785f36f594162faae2148964"
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