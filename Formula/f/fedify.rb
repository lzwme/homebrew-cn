class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https:fedify.devcli"
  url "https:github.comfedify-devfedifyarchiverefstags1.5.0.tar.gz"
  sha256 "aaf39a8a5c9127d958fe261deb95985a6f7a76994f4209af9466a75b7a993303"
  license "MIT"
  head "https:github.comfedify-devfedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a6eee481b77fb2cc8b85e957dfe44c7fffb6213bf4661fe5f374691d84c5747"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c932db99151454bf7659d7190be0481b20f6461e211fb1032c1984865fb06c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cdde9746fc8ae5857da9522997888f116976029b107b41799d7ebd59c11a5ecd"
    sha256 cellar: :any_skip_relocation, sonoma:        "621ea9b0a7f87d5766c94e8dd6e520cb2c6d3cddb9bf3e1626d3ed7c7da8d3d9"
    sha256 cellar: :any_skip_relocation, ventura:       "ed9365c520104884e3757af88bd75032392cddb20da56bb2f205f96a8f2d7ced"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d2a723c5c7ac8906491fa61b0c97c440ded92f3a5950f5d58ea502e42fea564"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3555b1f7d5585b8e81bf751c2fb12ba521793e22ef3389468340587595c7540b"
  end

  depends_on "deno" => :build

  def install
    system "deno", "task", "codegen"
    system "deno", "compile", "--allow-all", "--output=#{bin"fedify"}", "climod.ts"
    generate_completions_from_executable(bin"fedify", "completions")
  end

  test do
    # Skip test on Linux CI due to environment-specific failures that don't occur in local testing.
    # This test passes on macOS CI and all local environments (including Linux).
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    version_output = shell_output "NO_COLOR=1 #{bin}fedify --version"
    assert_equal "fedify #{version}", version_output.strip

    json = shell_output "#{bin}fedify lookup -e @homebrew@fosstodon.org"
    actor = JSON.parse(json)
    assert_equal "https:fosstodon.orgusershomebrew", actor.first["@id"]
  end
end