class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://ghfast.top/https://github.com/fedify-dev/fedify/archive/refs/tags/2.1.6.tar.gz"
  sha256 "40f17d309fed80e81afc45d3b70b0b499222766cce3f176f861e904358c80f13"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c6f19fe34b2916a46e4f6a074f78a235606df1e4d2f67eae6032e5595cacd06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17d97f49b65746ce97a8664e5f1328d4e497ee6d7a7a779b9f267e8d4dcf52b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3a4218dc7bb891b5625bbfa2a4afce25ddc69476446bd8a3e87a07089fe050b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bb27c3559339b3a66d9c3bfededa3e3e8003c24bd19a9f01a1de03b21c2d8f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f463a6f71dde2ec8acc285ee47cb32e422bff6b9eed3d3d4a2fdb3584923aea6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52b45c6e9c592f379b13c6c233a2031e3b3c787e6de45ae496f7c0cb1738f10b"
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