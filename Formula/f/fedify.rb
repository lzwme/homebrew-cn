class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://ghfast.top/https://github.com/fedify-dev/fedify/archive/refs/tags/1.7.5.tar.gz"
  sha256 "94ed72d54e60b02a6653dc45b027d2cd8ea1a191987cae58aa961b5937da7559"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40111a835001b7e8ada48e135aeb66547d40fff76ef755abd1c0843dbd1ba5c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e17ba45090d80ffe0a07b5bb65c85370daa657943cde88e4a8702049ef09fe7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "92b77f78993b8eb6d5028a632364b1652e954dc5d9dd58d612b5ad11005bd2ee"
    sha256                               sonoma:        "a45b037d267cb4b1614a98838f07f25f063642c317171fd109bc8ba200dfd5e6"
    sha256                               ventura:       "9ebd8d20c311b41737c94696d64a23456cbdd08628d9bb4757c41f695f1c587c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86a54318718e74db285a16e50195eecd2e5d298866530d7ac4dde04918805f96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29d1091f607411d75807bc413ba12e7f76557aa8c11e11a4c8b5d18f34f21692"
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