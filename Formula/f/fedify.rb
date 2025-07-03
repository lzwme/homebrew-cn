class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https:fedify.devcli"
  url "https:github.comfedify-devfedifyarchiverefstags1.7.2.tar.gz"
  sha256 "2aa330c35073cc9641bd0453589d84aa8baadec63c1efa3c57187184aa301fc4"
  license "MIT"
  head "https:github.comfedify-devfedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05b62a8471a4950c7a5ffbbf151a3524d1bbcb7d38b22003ecb5333f71d32cdb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69d5d042c6ab7766426ad9ae01b692c1220f3f110b1804f7a01cf619bbce4efb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec4568623b81d3d7bcfab9a466681c0bfc20e5eccd301acf3c15115c11bea311"
    sha256                               sonoma:        "ca3f5107733c96cd02c0b1b50c1e3b9d3f926ce9a25ec0ee523586e21f391c03"
    sha256                               ventura:       "c2f0594351346e18e4a5552dcd5e35000f2577151f7f62e37966bd58096c489e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5996905c918c564186835113a3efea0db196c1a708048b8cc3ac0b00279fac0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01a969459c4c2d52f6c04c73093ff4b42ed289bed9e66de76438e2667a68b346"
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