class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://ghfast.top/https://github.com/fedify-dev/fedify/archive/refs/tags/2.1.7.tar.gz"
  sha256 "20b2c53f0e861ece97a6b2bb8790aecca4021eff2d0e0a3d10353989640eb79e"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec0ec1dc24a116a92f3a86a4e4f7438ff88d38a41756029c54e96f01a0073896"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a25065db2bbd47a665773c9f3e289afd1cf2fcd39a54dc66797dcbb7dd5b87f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d0e843d734aa2b7c1e8454a3347f3f32e0dc056f9ec6dec16ebe68182dee62f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f0d37e377fe31f4955f6bfa95f6b4015a6911922c39ef8b4c7c0153ff76d376"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46137df3daf35374f4764168182aeba4046afa8ab297313b8ad84f6f6313fd16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91470906c8f83ad70fc71c4ce70f3193d8c32f399ab0a0c51cd762892c474320"
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