class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://ghfast.top/https://github.com/fedify-dev/fedify/archive/refs/tags/2.1.1.tar.gz"
  sha256 "cd17d53e1a72dc1dcf769c4509dd4f17a1d98dc14359fff652fb83c9c190c621"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36136378c53f71392e73581cab9ec867fabc47c78734651860ecbf474449d21c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e4128667a23e6a8a39fc7c7f83123c74331506fa968156186854bc9ee5c680f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37293a5fd7047373d3c2bd1f8bf8e101065814a4bbe49365cf69b864047c9fee"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fa77e34edd2112a0d678eb3c9b6cd540170bf7e3695eb7de0411919bfa8fee4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08b4203edd267004a1939b1d87830cda2e26b97385617d7b9d04b74a76e35852"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4914e2a641a18a7a4df6c1a55a55ab11c34a40b7c4165da54cb9c790b7bc3fb5"
  end

  depends_on "deno" => :build

  on_linux do
    # We use a workaround to prevent modification of the `fedify` binary
    # but this means brew cannot rewrite paths for non-default prefix
    pour_bottle? only_if: :default_prefix
  end

  def install
    system "deno", "task", "codegen"
    system "deno", "compile", "--allow-all", "--output=#{bin/"fedify"}", "packages/cli/src/mod.ts"
    generate_completions_from_executable(bin/"fedify", "completions")

    # FIXME: patchelf corrupts the ELF binary as Deno needs to find a magic
    # trailer string `d3n0l4nd` at a specific location. This workaround should
    # be made into a brew DSL to skip running patchelf.
    if OS.linux? && build.bottle?
      prefix.install bin/"fedify"
      Utils::Gzip.compress(prefix/"fedify")
    end
  end

  def post_install
    if (prefix/"fedify.gz").exist?
      system "gunzip", prefix/"fedify.gz"
      bin.install prefix/"fedify"
      (bin/"fedify").chmod 0755
    end
  end

  test do
    assert_match version.to_s, shell_output("NO_COLOR=1 #{bin}/fedify --version")

    json = shell_output "#{bin}/fedify lookup -e @homebrew@fosstodon.org"
    actor = JSON.parse(json)
    assert_equal "https://fosstodon.org/users/homebrew", actor.first["@id"]
  end
end