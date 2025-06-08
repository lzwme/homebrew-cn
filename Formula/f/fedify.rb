class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https:fedify.devcli"
  url "https:github.comfedify-devfedifyarchiverefstags1.6.1.tar.gz"
  sha256 "3c67d0d0129062a035adce56f71aaa127e926b62f7aff599c39b785d6c5e9ff8"
  license "MIT"
  head "https:github.comfedify-devfedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6cc14a1818340780edbe593eb2b2e0cabe62956ddfdda2d7ccce86b2629d1e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25601c2018ab21d44845e603f9862400ce34aadf5782bc2514431409ca01bac9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd8a069200938cb6d6a9f1e5ed2ee76370788e6ce540674c8833647b2162b5aa"
    sha256                               sonoma:        "2f79f975395de9276e4f6d790e8657397fd2defee1d80f613809394af75a73ca"
    sha256                               ventura:       "bc970a07eb535ac96a70351c80d6d0efaa25c8408faa84ca0e44337aa78c689b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a15e1d148e20bedd27a713f041105a96dd2ccebc825cd682819c46b44b23d949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0885ada1dad0381a9ea81771506f5a7a72e8a982ae6907f54667b07630c7f76"
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