class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://ghfast.top/https://github.com/fedify-dev/fedify/archive/refs/tags/2.0.0.tar.gz"
  sha256 "e831aea1dbe20a0c42beda1abe9e03ff65ebc1743720afcc214b4758c134f8c0"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f00ccd50c9feb38c8f66c71177f72e1592e046dcc6338e7a50821873cadbafd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6d0095e3ca7d05273a1571c900807437f831d858ef97d096fa3134c43a30105"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48e755f699ded141a701063c346ee725419b74b0934fc214ea838ad54679d142"
    sha256 cellar: :any_skip_relocation, sonoma:        "652baf295b230c96917c2c0f88d196aa65873f2a69b5fa64d2a5db8b504cba54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1847b038ac2a39987a3b502bf437a74bb98a7f7dfd5b6ee9c2fdaa5b2ad69079"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77988a5eebf3f8c4e76d54f768a816b2b5cfdfbd0259af26e1da21da4aededd7"
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