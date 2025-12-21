class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://ghfast.top/https://github.com/fedify-dev/fedify/archive/refs/tags/1.9.2.tar.gz"
  sha256 "54ea289a6ad6131d422adcde680d8297b09dddafd870b83e855f02c5605a80b1"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43e450a01bc6c58bb307d1c96d2c2ff68324c3c5186b1fd0f985f4072cd3111b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2602f4e0c51eeca186c16ac73180cbe9d68ab544c49b2f8a5dd0bb98e246dba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92e30c4b673d666429bcf058eaf7510bdfd58cfd51fd4c143aa376cf255b6f89"
    sha256 cellar: :any_skip_relocation, sonoma:        "9be8009b72a9ffbec948ddeb2cdf69f193c3b4cfecffdfde43fce6c4a4331030"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e503a668f0e0f253a307001f6b7863946d5b658ea4bdfa0271a4cc6457ef1c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60216979a173003a84c4770f1492cc3a8d029423608ed2f8514a6299ee5576f5"
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