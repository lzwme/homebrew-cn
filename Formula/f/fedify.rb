class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://ghfast.top/https://github.com/fedify-dev/fedify/archive/refs/tags/2.0.3.tar.gz"
  sha256 "a0a447ead69004b271177258fc65154c2f91c09b9b4254e1a90e14c25cb81f12"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "162bae0f688770e30654d6def9c3277d6e5e317fa94bb627f94837e2ebb486e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f864712dfd5060b57cfa0f1fd00fab22aaf72ffa4c63627459f75fad117ad3f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10f61b78ec7b612a79c7bf5f27074ab31183879bfb867c117d26fd30873bc54f"
    sha256 cellar: :any_skip_relocation, sonoma:        "deb1bd0a1f9eb2c49bf9f2217ef7ff76b1a7264526f9b697862bb47b835a1007"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af12c5a9732a9dab3588b21d07bc4ef4dd2d9d5cbf6f994f6e59a9fa37c1e7a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a434cde7e8c8683cde4afa2399d012118433124cb00f0a03fbba1e7d742e2142"
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