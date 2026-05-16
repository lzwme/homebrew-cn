class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://ghfast.top/https://github.com/fedify-dev/fedify/archive/refs/tags/2.2.2.tar.gz"
  sha256 "38a2ef35683256db3a9cf509df17cbea18fb5cdfff360b4c15707758b56bd14e"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a36133a0bfeb4af39e529934270c6c5188b7227a5c60bb84f26ab751709e0c3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5e02f79e425cbac23a1b3d607a1c4edb11ec020d071a6b5eb92131203bc6a65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c277b92f9571af692809265179c1e9975c0d983a80b196d39409a777da0398f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d768a916d024ef038a72c246201e521938aee78384f72311d19a4c7842379638"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d9e8440db7b6af2cfc42a29de9cd90b0f4e15c4c1188c8c153dd2d72603f0d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "faecef21cfdfe64b243b15cbc09d9eafbf5f6de7fe66f8c55da03fb3329241d6"
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