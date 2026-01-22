class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://ghfast.top/https://github.com/fedify-dev/fedify/archive/refs/tags/1.10.1.tar.gz"
  sha256 "e2086357eabe44257bba416d56b8647c617238a06bf5cb593dd73619bce70a66"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2be1751a1bbd46c57c0d6af5438a9db7eaafe11e904e36a06dc8431672a1d41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec19110c839734f3484e974e07ddda3098fc16964f60f8cfdf9ad5cd989c5f5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ef156353028adb2f7315883b7adff87ba79927e659360abbf0cae8fc779f2e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f65b40f0d2d83f50d908c658b8a4e5457b9df836638f664bbad56826b239a588"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2187afc169ce4e62118ff4d8c62110b636b43d7ec41de7313ffd5d99d30a9ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9d28c6e7e84892e6999499a131bb4855873472f00a6cf03df427a39ce4b2999"
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
    version_output = shell_output "NO_COLOR=1 #{bin}/fedify --version"
    assert_equal "fedify #{version}", version_output.strip

    json = shell_output "#{bin}/fedify lookup -e @homebrew@fosstodon.org"
    actor = JSON.parse(json)
    assert_equal "https://fosstodon.org/users/homebrew", actor.first["@id"]
  end
end