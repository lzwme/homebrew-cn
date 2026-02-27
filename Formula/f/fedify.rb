class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://ghfast.top/https://github.com/fedify-dev/fedify/archive/refs/tags/2.0.2.tar.gz"
  sha256 "c9a6bd5b3f07a05069880b004a68c653cfd6b0c306dbb93e97bea6227f31b9bd"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76f96e44001914570f5196511a038c1b26daed6e749516da4a9b3f9a75864b83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5d1441c0bf726c5503d8709d84cdde9da6186a441708ab0320b5cc90784020d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20de3f2f3c7ef5a0da1fe372eb5609262ed02f9142a062091b2d2a08f33055d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4ed9170b738f3394876683652e724ebc197b8e299c82761e1ee5a5eaf73a89a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "642efd7130192408f0ecea791148d2f478feba0a5d29d5fa781246fe07e56a4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6185a64c98acfd1d231b6b8de9e7056502fc9be3db88471b60b362740f9c695"
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