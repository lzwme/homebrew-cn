class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-21.2.1.tgz"
  sha256 "b557b2fccc5005fc9775c5800e314c5975c40343556292513265c8b170c0c9a7"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "6e5676e52a6fe801ad3017e0010477a48261176e93810672b5b397b037b23139"
    sha256                               arm64_sonoma:  "dae5359f9cc59300b49a360be3a2f592024ac2759623600a3d0b29e14fe6115c"
    sha256                               arm64_ventura: "d11a7f00fe3057c69c53007b33fd6ca4ffd63757720b901d0f29ea1929d7f98b"
    sha256                               sonoma:        "d94b5f5f17fb7cd957fc915f1ce457ee59759acd7f3c235ac2da666e201f7b52"
    sha256                               ventura:       "27aac5f72c52b82948fe87edb705461474a76ac9fa8d55a0ae9ff9c07af9504d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "767e969577e2b870531fa29249ee5955c996a5a92665f0f59c18f6ed9ed35245"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41741aa6f263b25b8891642e1639441cc42ae0d7e7c40330ec9b2ffcfb29099a"
  end

  depends_on "node"

  on_linux do
    depends_on "glib"
    depends_on "gmp"
    depends_on "vips"
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin*")

    # Remove incompatible pre-built binaries
    node_modules = libexec"libnode_modulesnetlify-clinode_modules"

    if OS.linux?
      (node_modules"@lmdblmdb-linux-x64").glob("*.musl.node").map(&:unlink)
      (node_modules"@msgpackr-extractmsgpackr-extract-linux-x64").glob("*.musl.node").map(&:unlink)
    end

    clipboardy_fallbacks_dir = node_modules"clipboardyfallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin"xsel").relative_path_from(linux_dir), linux_dir
    end

    # Remove incompatible pre-built `bare-fs``bare-os` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os}prebuilds*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}netlify status")
  end
end