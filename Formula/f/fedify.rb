class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://ghfast.top/https://github.com/fedify-dev/fedify/archive/refs/tags/1.9.0.tar.gz"
  sha256 "74a806aae95f37650804fcdae5d146963c83eda9f0e5348ec9da341bd694c013"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b03c16fe30af02be91b0fc38dcd6668582549eac01365130ccc1ab7fde37c644"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e57937eb7125af08bb4ee2a5d2392cfc3a6659c556d98fc97c1e38ebf4394d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6ab5ef6cc4b801d3cc26f1feae77a0fa195fca460c983f92b681cff1ccf177f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4283c6b7a1245dad9602ac621ae2392d72db86af28850786a7e687f226b1f38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10f53e2645d8eb66de99c03465c4336f211aac846f712d0ee9b9e6730dce75be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4e49db4eb34f7244a1eb951331f6f2d385da83a74193b24a54b3d48b59de92c"
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