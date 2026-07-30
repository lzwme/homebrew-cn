class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://ghfast.top/https://github.com/fedify-dev/fedify/archive/refs/tags/2.3.4.tar.gz"
  sha256 "533d9ce174354a8a3dfac051728ed632e77a04d7514adc3d6150d3a866b06c44"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5153411632ac1909737eb81c2007ac71845088cbcd194b7016960f54f8fe706a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4f284e3ffb20d12a196dabe61b41babd8a8ceaec1ec7ee830ed5c10499621f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3660f20b01fcc09649e2bd05ed02284938f4e99f0519a20a19cae18da88ca49b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6edd4c6eaec44ebc44d92bdfa81a4030c625fdc8cae52a0c3bc35bb09d80e08b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9dbd24f3b2ff54e3c2695e7452448ebd75ff5aab7dba84c82877aa0f3dff7f41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9946cd382132c46a710c99cf430943c910780b818b78691f303bcbbd054cbc9a"
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

  post_install_steps do
    install_gzipped_executable "fedify.gz", "bin/fedify"
  end

  test do
    assert_match version.to_s, shell_output("NO_COLOR=1 #{bin}/fedify --version")

    json = shell_output "#{bin}/fedify lookup -e @homebrew@fosstodon.org"
    actor = JSON.parse(json)
    assert_equal "https://fosstodon.org/users/homebrew", actor.first["@id"]
  end
end