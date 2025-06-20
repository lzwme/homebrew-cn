class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https:fedify.devcli"
  url "https:github.comfedify-devfedifyarchiverefstags1.6.2.tar.gz"
  sha256 "15b0350388a8d20187edd23e8aa3ffd581152a178b422459d90ad2bdefb13f64"
  license "MIT"
  head "https:github.comfedify-devfedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a90375931714ad1c215e4f6b3cf545b58236120c24f5132346ac16b0a4c7fd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "488eb125a0c0a58e23c22ee6a5bd0a29d94f38aff7b5d432450b9a913fc48b16"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "77f6c9e086b37454605cf2997cf64ababe3f262680eb3d307383ff9bebfbb2e8"
    sha256                               sonoma:        "f1a8738b1578eb1a68a4bec5151bc672bf4a147130cbb4c75178d371610ab255"
    sha256                               ventura:       "549eddfb81348a429d01861743f75f4b1ac73377c58da3c8be634bffecb3f271"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1706fbfb2544c2556f6a15e38940d47077293a9630a9c7e02586a6d5a1fed9f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14929795eff8a4106ed4c1d542b92cdb69af881e1f200a555dac791a0f3dd2b7"
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