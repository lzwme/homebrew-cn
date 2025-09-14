class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://ghfast.top/https://github.com/fedify-dev/fedify/archive/refs/tags/1.8.9.tar.gz"
  sha256 "afe85e8eb888f692a587595448152129777420c513d6dd129561361daafa0e27"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dac9f2b10e1775a6f100df58622fae969067e779b7ae3df08ae21b6fde2028b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61c6721a2d1db4e83b5681a10ebca06b02efdb2e5754b6c599758630f962ebf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fe1fe50436d1a8e859188be1f4ec18592257bfe657bbbbff55cd20dd5179ae7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e9d884817e92088553307a86e706ccee55a5d1e796f2ab6e32436ba42f74d79c"
    sha256 cellar: :any_skip_relocation, sonoma:        "12af6a09f7d2431df68439a6fb6550c936da75ce56c4095a565cf88d5ed40148"
    sha256 cellar: :any_skip_relocation, ventura:       "e9aa17e70d1f6390c04635a4e2fb312efbf29f4c246af33a64a26ce17da6a874"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64e2600463937f1b765a41d1570ad57c93f0d1663ae9c230d636b289846d9f79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d5fa8b4251fde76378cfdeb12fb3554d00f2ad96c87e4f375b7b6d571d3430d"
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