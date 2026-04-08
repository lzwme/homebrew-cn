class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://ghfast.top/https://github.com/fedify-dev/fedify/archive/refs/tags/2.1.4.tar.gz"
  sha256 "dbcecac2f085ab9de8907478542c8a1a30d7aa7f591e3a717e41c326f6994927"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c86e375940a543a676528ca736fb71a99939669212069bd4ab9def58b678fb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3a3ffd6ca8dd36a2ffaf7c96da95411715d4f16267eb655076ec43f57c940b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "daaf881ece240aca3e2ddf3fdfca994594018a626d9fff13135b910e0df8e431"
    sha256 cellar: :any_skip_relocation, sonoma:        "90108fea989bb15a379cdfc7b06852da21f71a76f7fb47354b32570293f4559e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6ddeb804dbc07054aec7511311ad1657708b1460e5d6e13e0b7c30cc098d36b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb785c6edbb495feaffe7c5d114afaf6fe3b36ba6a20fcc7d6b28b952f6fb5fa"
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