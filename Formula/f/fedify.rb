class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://ghfast.top/https://github.com/fedify-dev/fedify/archive/refs/tags/2.1.9.tar.gz"
  sha256 "2ebc4f8e78f40753555aaf1f01babf954a2540e01cb6d13ee6ee515a3e3aedbe"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "754d205b619d39ae1933a3cbff1b16f64aa3af2673b37f68893002feccf7751d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcee003e02c9ffcc50aa47b2667fdeef980b4143d2336b5e1e2e58afaf7b7f62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "373c7e2bfa7051f451e9e47ffc77550c4ee1a3786aa72c2db57a3dfb8a149317"
    sha256 cellar: :any_skip_relocation, sonoma:        "817698242e08b67020e0584a632c54d04d70ef947d8cf79f12cf7fef9aabd32f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3bc6985250518744b7a27b2342aa16710da54aeb7cb219a11488a36727ff517"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64d75854f8d4a81962c9392072e2e23d0a91e2749be3ad95ba988d4adf84c080"
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