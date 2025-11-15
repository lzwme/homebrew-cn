class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.43.17.crate"
  sha256 "ab35dbb53c6d7d915d831ab9c9859c6a92cd0ddb55a2d952ccbd7d60a7c5512a"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c80871176e6f054f578902e4bdbde5e4cad019cab006e133791176989e11e77c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47c651d43fdc52cf343bd1ecd532b58c717da7d99f299981d31605e917c6d8ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "753ef0133ba339cfad79cffa6c9246d469a4d3623806d05d98ea66d548324127"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf36adcca3c6e0b61a0a45aa0c4bd6f4fb7866a7c23e3358c723e1178124b2da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64fbbd7cfd97e5b828365aed05562d054dd1a773c75936f2ef54ff5180f5099c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae8525df7e342302553460e778945c0044c067af97f740ee6a44745b14edd55a"
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