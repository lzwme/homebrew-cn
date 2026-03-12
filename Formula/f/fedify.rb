class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://ghfast.top/https://github.com/fedify-dev/fedify/archive/refs/tags/2.0.5.tar.gz"
  sha256 "f00fbd122ee535d4df22254ef61fd6b277fe69142c017ac5845dc674a7edd598"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13aa869a0203c7cb943fc67de937b81c08b5b541c3ddb6502b82ddd895f397b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7533e8a019f03c5dccd2eba91ed372907566cd77c0f461cfccb742d736b4acb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51e2fefab2c0be01a5b087d642e5011d36d3eac606be6098b36fb2d4e0a2d8cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7940ab57ba84d30dd52808f4e691f7aa208c42e600838f31c2fe2702f6f1bae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88d243e76fc3012846b4d3dae438c1c04b4af5f4ccc983263ffa2d184a26d12e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c097c5d724a9ef8d9273ba4d1355afe06b20164356513b496a20900ba785f67e"
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