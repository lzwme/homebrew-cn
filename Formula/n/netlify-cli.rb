require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.21.2.tgz"
  sha256 "193511145520f511f06c37d5c11ca158cb8d950df8f928498c3c873773910668"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "0497e65c9c794b9bd81555c2af508ce70a25efcb49b8165d4bfa785ebae24dc9"
    sha256                               arm64_ventura:  "70039c1be530dcd7f855650a2a5ea187c13d1b29b915c08187d8d565c68d99b3"
    sha256                               arm64_monterey: "99d1651758094c6e3d2565131312591b1cc58d4577e2863f7b3a122fdc7f4e05"
    sha256                               sonoma:         "f02cd4c0c1ecdb6af494c56219a7f291181d197dc1bcbdc186c777dccca1479a"
    sha256                               ventura:        "be33f2476a8dd36c617cfe59ce995582098f53e61010a5b780e71bcbb71dcbaf"
    sha256                               monterey:       "4d092c1d38ac3f4f9f8be48c680274ba2c0c8dea5fec4055fb696ea31e80761c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7bd91961037cd7823f98b2b654a9ebc46a78f1a0ea2e2062ac24c55dc364237"
  end

  depends_on "node"

  on_linux do
    depends_on "vips"
    depends_on "xsel"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]

    # Remove incompatible pre-built binaries
    node_modules = libexec"libnode_modulesnetlify-clinode_modules"

    if OS.linux?
      (node_modules"@lmdblmdb-linux-x64").glob("*.musl.node").map(&:unlink)
      (node_modules"@msgpackr-extractmsgpackr-extract-linux-x64").glob("*.musl.node").map(&:unlink)
    end

    clipboardy_fallbacks_dir = node_modules"clipboardyfallbacks"
    clipboardy_fallbacks_dir.rmtree # remove pre-built binaries
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
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}netlify status")
  end
end