class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://ghfast.top/https://github.com/fedify-dev/fedify/archive/refs/tags/2.1.0.tar.gz"
  sha256 "421cd41101454fda2aa0dc281e68002e36083e642da15344baf38935c999a081"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c0b5131d26402aa2f8a8c6b96f90fb4b9afb14fc7dfc49e79c28aa08d5a625e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "459740b6fc10e6105ecdee86975ac5992fc69722b13dec51db65b9cc49c81fc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa4df8e19aa60814ec6a7303b31b834845bea51c40470ebfc2b17aa0f6a635c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "59d57da122a7ede461925bb676438ce8729719ab20762156469056e7b2b59eab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb9c486face34b01826d323b279d0d6c56566b3e9f2773628a1f2a4454e7a3b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b707ff98a19b85636a31a4fcbac2a7f8e5026515c3f948d85ef3546e87875551"
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