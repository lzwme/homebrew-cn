class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https:fedify.devcli"
  url "https:github.comfedify-devfedifyarchiverefstags1.7.1.tar.gz"
  sha256 "66b42bdfa4049aac8ab35d37c3a788d8f857813d67fb34627f2cb31373e44a7e"
  license "MIT"
  head "https:github.comfedify-devfedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a2ce4774c2572ff9022619f96f56fdd4842e91d3ad8f5c0c9752e1ce407ff86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cbf1bdc7c2af063cfcb8ce1a92ba080521b9bc11255fcc64552e23782e06157"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1eb0881b84daccc0b3223f96fc09d5f5db78d059fb7a96564a83f1120ebaf67b"
    sha256                               sonoma:        "e4b1ebd4a87d008fa9141655fd67ecd1d109eee115ab0314e22492395e630461"
    sha256                               ventura:       "9d35a9629705d93491a8f8eb2ebdf0f1175ba419229fa90fd323eb3485f2088c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51cdbecaeb6d8360acb993ff9d9292ecc52eb40fd72da938309d1194ea4949c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2707ddee567eb62b2cec07a8e2ef9f565d2ab38ed6f0cd402d42320fd61a0249"
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