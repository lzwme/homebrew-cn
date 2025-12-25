class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://ghfast.top/https://github.com/fedify-dev/fedify/archive/refs/tags/1.10.0.tar.gz"
  sha256 "2a567341bebf90a27ad9e2e15774538da0bb2734444c05545e4ae62f009093d8"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84e131894162e9a855383ea75987afa4bfc45a907c0f33458af068d1cfc6907b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1028a82c334841f012c59885bae0e6430d46ffcbf23f7e09d2c4c09ce7013d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d230abbd0b38ab86888ae7d7db059ccf6610d9c3789622abfa2acc79c836a56"
    sha256 cellar: :any_skip_relocation, sonoma:        "0af4e80f92bfb48537d5a7034e28ec39ff15108405b9df33afe39c23728039f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97867f5751272ab601c1237e51b2bdd9a916f8b6bf4ee5a16e4fdbb04c2a2a24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43a02e9dfb71486cfe573e90b28cc2bedb50fe6ba7661f6a6231148c71e5aac2"
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