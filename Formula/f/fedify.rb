class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://ghfast.top/https://github.com/fedify-dev/fedify/archive/refs/tags/2.1.2.tar.gz"
  sha256 "3cfd3a2e7a647f5c99d6b55b887f1e32633ed72188119fdd0bdd9e1e449c671f"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57fda54c12b6123a77c7eea54de28fbbc801423d64e3d7fadec9f5e8665f72ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d9f1870bd3aec7f96d6af8e7a79150fdbfa880809aa4b63672a42a5e5232a74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ca7c14a5909ec337892ffa5c9c9e819f3310169c05e204755c23b170434742d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e5a82255a3a4b1a749eada74444e9e9dbd8d19d50a8a06b471d9da8c1e002a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "692ed64cd3ad89946f627b8cfabfdb1ba0df220748872ab5687a055231cd1031"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6e1fd9184b14fd4183b803969250a63ee3623fb9005f8ba121cb92667a7383b"
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