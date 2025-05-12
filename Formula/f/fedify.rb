class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https:fedify.devcli"
  url "https:github.comfedify-devfedifyarchiverefstags1.5.2.tar.gz"
  sha256 "9bc5a6c36599b87f51f9d83d8fa314e0037e591fe64ecca6607d78e3d0200260"
  license "MIT"
  head "https:github.comfedify-devfedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "032fbf656a501284f5e83335ca390858841b8bc6b6b7bdbf96ff24b5e00da533"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4c24445bcf9a7046c0dd7f52041b811eb7a92f246092741b359d5643cda7047"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d90385744855e253da3a863a6f13998de3d1c2a6ac05b69dd830186fc9b95db"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef9a0c28c4420eae01523f3167ec5a66ff939bbbf7b62c8fec42d732979a045d"
    sha256 cellar: :any_skip_relocation, ventura:       "5ac2f41532a4c9a0e157a3adffea357fb11fdb00166c742cdd1273f284e30db4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0edf56ceec017df22d07ffdf39aae8eefd19cb8b61d29183b1488c2a4e510199"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "200b8247edce833fcf9fbca01ccd46b5b2e58b395b18f4bd38d9d0036a290de6"
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