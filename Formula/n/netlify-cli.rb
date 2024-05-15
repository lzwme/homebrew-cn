require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.23.5.tgz"
  sha256 "3c1a15af0625eb8702939e710e7a4113ee799e2640c0e6d119ebb9f9f69fc996"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "995ef61d19e0a69d6d13438feabd6541549b04cd56033918f9ced832dda02853"
    sha256                               arm64_ventura:  "b1dc662a4f4639d6d763c26c3e22ec89ed154361a26b4f5d5fd9477e1bea8b31"
    sha256                               arm64_monterey: "822b4cd26dead61e724a672b17400ccfdee89e3581851214791f0c20d0ec8aea"
    sha256                               sonoma:         "650c03de9ca0edfbc22718126b6ecbaa97c87a8b55559909fea8ecedd53d5175"
    sha256                               ventura:        "91081b8b1b406aba64df266a2c6b7d388926f44e5fed2efa92a30e0fc58b90d9"
    sha256                               monterey:       "85b721e187bd2303098fd0fdaa6393277c0e8a0b51896e10134b9804e6344ee0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6f9b0c9cd42a96fcee32b154d14df8c94f390ba8139a6181eb56a117e46ee26"
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