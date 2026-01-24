class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://ghfast.top/https://github.com/fedify-dev/fedify/archive/refs/tags/1.10.2.tar.gz"
  sha256 "832fa8a81ece6027b8828bd1ca3ffb9091bfb3231bea98de71a3af518443cb46"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88c4f5067ac97a671ff6b19ce3cd02c896d36d2cee34fa6cb4aaae33e1f280c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "279c83bb7399fa17f8e42d7f34652f1731fad9d60bdc6f01305c5717f7794c5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "038fbeb286f6c6a29462808561a8b64a97afa8b8963627176f6f1209b83844b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f2154175054b884b36ae4d6052e1bff8f981f1799f61bb801a8132e79f1f2c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "197396971acb53963873056532df99d49759102b35125ee2ab0a443e6850cdcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59b8f4fafc80a2f589543a9525f758cf96765b611a98eecbd6663b02b96ae3e7"
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