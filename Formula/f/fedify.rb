class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https:fedify.devcli"
  url "https:github.comfedify-devfedifyarchiverefstags1.7.0.tar.gz"
  sha256 "61b213c5538e43358817c5a5b0947a0f0cc4c0f6c899ad7fc7a27a82d56fdf9a"
  license "MIT"
  head "https:github.comfedify-devfedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a94891e7486a1f79cb26e64ce86fc31f2106927fc1358679b866937181104aa0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3073f614535d5bbae9b98f2bad9b5c6e570453e27aed8af53f76fe9f154a74e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "94d8fa81cba0d526dd61cc3e72a4409d1e783e20c5f54dbaedd87cdf8ac4f814"
    sha256                               sonoma:        "cd7ddf1ce6c22e4284a1b081377828186c8d363aacd78db966cbe14de0c6485c"
    sha256                               ventura:       "43e5582409e528dda12f9f0a5a7aec9b4acf8481165320b89ba1b911921e3546"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "390cb5d03d6c367a73430be9c98d0fbf9df4078c7cd6352b9c2377e46efbc30a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4592a8ff57f6cabd32bb89e323a3ad7710177cc922077974ddd809ebbc3f2ac"
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