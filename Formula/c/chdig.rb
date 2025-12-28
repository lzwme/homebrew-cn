class Chdig < Formula
  desc "Dig into ClickHouse with TUI interface"
  homepage "https://github.com/azat/chdig"
  url "https://ghfast.top/https://github.com/azat/chdig/archive/refs/tags/v25.12.1.tar.gz"
  sha256 "29ac1562d0f97c8d6c6abd5d67b111d9291e34bfc6b953319d16148ac2cd3e47"
  license "MIT"
  head "https://github.com/azat/chdig.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5026c0f95bf0ccdcaa10a00697fce455b1898350bf49f1d20e8c149e3c3eea2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38d287710f731bce110bf68a327d1b2ca7a5abff58a5daecdfb9f3738257a818"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eee852bc746bf2b999ffbbc7bc874ea1d8a271451d7063f881878a0ea28478ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e05388b109c6baffb4b843abb8673411204cbfefbb25fd9aa5213170a385ecd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e04f7c88d63fa8b777d439eea15b38c414c91cb40bbbe098959a666ed3403d7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10c1d4d2b1647b8d07636769eff72de7c6b51d9cf87bc29e82d991d9e0365182"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"chdig", "--completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chdig --version")

    output = shell_output("#{bin}/chdig --url 255.255.255.255 dictionaries 2>&1", 1)
    assert_match "Error: Cannot connect to ClickHouse", output
  end
end