class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://ghfast.top/https://github.com/fedify-dev/fedify/archive/refs/tags/1.7.3.tar.gz"
  sha256 "073b85da0079de715349c7074de4aab620896476761ab3ec781e7459acc601b6"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a6eeda0da360d1c1cbc9b8cfcd1cacca417d812ff601d2d01633a1f1a1ec175"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee03adc5f76c34d8e5cf93d4535c9c96260b86e58b7e750020af8a512b6aff4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dbc34dbd6dcd2864f25b7bfe91ec09d5ad438e191a7345538191628e6eaf6a5f"
    sha256                               sonoma:        "6ddb05539ed4aebd547eb05eaa84b640d50dcdfb8d763b96de84c24ea12cdf78"
    sha256                               ventura:       "905da7a2b7e6dce486c6d47d58043869edce6a1ec1b99f2db7a82162d1b116fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a91cf2c04c835bab4d5a665fafa60f722549b1aefc89bf3dd8c9e80afd5df9f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee6b1c13538fc5038caad63db9b3c316e2ac4985cc9fcf5cdc699fa44039cbf5"
  end

  depends_on "deno" => :build

  def install
    system "deno", "task", "codegen"
    system "deno", "compile", "--allow-all", "--output=#{bin/"fedify"}", "cli/mod.ts"
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