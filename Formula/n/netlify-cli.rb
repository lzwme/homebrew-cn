require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.29.0.tgz"
  sha256 "d54092dfbf3cda3db0dd0586450dec02fc4a1400e75989ad7e69d6ca745a408b"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "64b3b664d75b113a8f5752d39eaf8b9adf956f6249041c74a8a581c4c9c0be6d"
    sha256                               arm64_ventura:  "5ae3a22365096c72cf4484891857e58a41dc2cdd2c9e398982d6e33c0ecd8803"
    sha256                               arm64_monterey: "776ab2397c6469573bd44338577c09e9d826ec6a78968df354c6be8018cb9938"
    sha256                               sonoma:         "2dba56393a540a3943d452c67fcc1f8a7de7dd6e41f7f03d494a92cf598045dd"
    sha256                               ventura:        "1575884d42358965057acd14cc02b9979ac2c42e411145fefb2db0cb19f7dbf3"
    sha256                               monterey:       "864937c933a272b6938d087cdf6d358c80e2f6427371356d72ca0ebcb4c88d35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f97f1ee26bfbf0fb08d400d7be0e59a71be5838cdff1706e0cbcb717789c99ff"
  end

  depends_on "node"

  on_linux do
    depends_on "glib"
    depends_on "gmp"
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