class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://ghfast.top/https://github.com/fedify-dev/fedify/archive/refs/tags/1.8.6.tar.gz"
  sha256 "9b60e08aeac31a7c698147d159e5b0e045d79347c92c6f7c5c68d95e6260168a"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e24f74e23a8c3a9fbf8c5b8ef33c53e607376a286b59018c0f6d5eecf5bac07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d78ca8301c61131f184217cc5914ed1dfcba4fb52c8f73df4ec8d3799650504"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b6866e504232ee20b0ab7854a55b63d9e4d5a3254d9ea83c034d9b1968a1eaf2"
    sha256 cellar: :any_skip_relocation, sonoma:        "739806628ed383ebee1576b1498c8f3c6bd3a87e4b9bd66ddf69d623f5d2d6e7"
    sha256 cellar: :any_skip_relocation, ventura:       "b21869a4cd8049be3dc623475dbdb37aa885607fb2f05469721ce8498447a1c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2506710344be4d296e0ca2e181a2bb965600d70637bedc158b085a7ac0746fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2963043c96b330fb709fe51d582538e166124e07c1e7fec6d21954f12050cd21"
  end

  depends_on "deno" => :build

  def install
    system "deno", "task", "codegen"
    system "deno", "compile", "--allow-all", "--output=#{bin/"fedify"}", "packages/cli/src/mod.ts"
    generate_completions_from_executable(bin/"fedify", "completions")
  end

  test do
    # Skip test on Linux CI due to environment-specific failures that don't occur in local testing.
    # This test passes on macOS CI and all local environments (including Linux).
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    version_output = shell_output "NO_COLOR=1 #{bin}/fedify --version"
    assert_equal "fedify #{version}", version_output.strip

    json = shell_output "#{bin}/fedify lookup -e @homebrew@fosstodon.org"
    actor = JSON.parse(json)
    assert_equal "https://fosstodon.org/users/homebrew", actor.first["@id"]
  end
end