class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://ghfast.top/https://github.com/fedify-dev/fedify/archive/refs/tags/2.1.3.tar.gz"
  sha256 "50104500a9cb53d2c02bfcb7bee2707fff7c2b265a2b27e7de1f0997cb5b1092"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1beca944fa43f8dfa3e56ebb7e17a259aa2339c3fb58de5f64a6d4193e3b40b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99d14a8aaf37c2b3639ecc88931910cacac9167177c3ff179d3751a1a72439de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f89bca9c44f55c69e01059997c07b2db1515934a696c229f4da15f97d245c603"
    sha256 cellar: :any_skip_relocation, sonoma:        "45ed867b1009e8fc296db1124be3de1b7ccc7bccd19db13249f2954bc8c10fea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b3ac45b7c3251012a0932eb25c0b7595ac004cf753aa74dfec4e00449ed4a7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3db1baee68b3eb08dbeac995cfb071810a5b96fd5e503ae4393549bc3dd02d47"
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