class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.74.0.crate"
  sha256 "095f27a486f4d6617be2d03db79399f853ed2ec3f87bd3af829891e7060cb12f"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32d0272a45c2840a71d6a45c26c156cc83ff888eb4d3e293411f1364ea59d03f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "647b3f84a088687ce3e3c7e1902ce26c1bd0b798b07a54594c5584063a1790f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c24960fb3f779581e94c1a8d3b11f55759fd0bc218943e73a1c9d376fe6df51"
    sha256 cellar: :any_skip_relocation, sonoma:        "a55def06055607bed7d0299f907cb93463b9cdb778fb1f894393496666fd471a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6cfb977309b3eee86ec8472ee4e63d14629af9fb63443ad35ad1219261f3121"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcdfb203fc5d7782750784ac3fd5663948cdff126ebac296f9fbe83ecce1eabb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "gpt-5", output
  end
end