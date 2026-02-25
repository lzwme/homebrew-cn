class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://ghfast.top/https://github.com/fedify-dev/fedify/archive/refs/tags/2.0.1.tar.gz"
  sha256 "0525fb5de7a062d85fe912d38dfd667f51e3bce8f2fdbfad0ada2dbe05f04f8c"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "940bdca16e51956bbd6298de49dcc6fb9da949f2130813706bbb8fd51c3a7f54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13478cc572dd5cb0a9a21643f09484dad31abf7fd826dc9b41a6a121486055a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "140f46728d410ecf3711f0514c1e08cfde23a9af6a5499284277129053e04a2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa54bc210b6a0d23275c9800b92955c7871a1249134a2c07101a488a4ad9a531"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18c8fdd2108a4fb6a5970cb57f4d60a25d131557e284dd4295ac8a02b0647cdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "404b94013cf81512cdccf7e6a5bc50d645c1f2d9c383083eb170a7f48c22cc34"
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