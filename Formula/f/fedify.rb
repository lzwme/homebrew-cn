class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://ghfast.top/https://github.com/fedify-dev/fedify/archive/refs/tags/1.8.10.tar.gz"
  sha256 "3ddc74a30ac5c930977cb3837321e5629144418725d7f7f2ad6b341235164cb3"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e523f61d8c667a718de1e001827ab4dcfa39c558ed492cf6eb1e271a4e32f64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dedbfc04e44eff7c3c7bebfeeeed7b92e74fcbda2fb244c97916e0b5cdd873d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "256eb5200f0f723424625899c5605ed86f96b47991d9093256cb68716e986826"
    sha256 cellar: :any_skip_relocation, sonoma:        "07944c2b535dc225416b9195cc354eb2b179faba2a2e4f058b218ba6465c572a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e797669e36f0f5fc53ca46e7e86b1d391574f93d5c051fb74f0fab12c40cbbce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1c6ffbc8a27d77c424be123ad86f4480fc8f738421ff488fc976d7fa9f1141b"
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