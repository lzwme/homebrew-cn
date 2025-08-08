class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://ghfast.top/https://github.com/fedify-dev/fedify/archive/refs/tags/1.8.5.tar.gz"
  sha256 "e32188d519cb7334de84acda2a236f1303e96a7fc60183fb0e49706f0697ccb4"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d61e0f2af073e224417943407b3d90e799c977928bf756fbb6fca56b814bab8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d9b1fb229266e75c1bf9c539f1ff859f8e71507edc3047eace54274b5f0838e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "76c1c4853a8e67cea8fb92850b4ef0df1f5a03eacd12d6b3cb0d604a35ab8e8d"
    sha256                               sonoma:        "eba85ecaaa2d120c44bc519ad3195327ba9558bc5a384bda568b86d62be69026"
    sha256                               ventura:       "cb52934d2e62b182d11f65cccf4d9fe1b48893a64e9bd45e74a0a04d9b26e522"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c06bd5d30faeeea32ed953ec9803e7a4ba21738af6c4ceaa138027e708ca6193"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aae6694a5a92cc3647e9da1206aa0245a500b154b56e358f0444548e146a9227"
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