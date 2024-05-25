require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.23.8.tgz"
  sha256 "c09f0b51a5837ef6b8bf51f0d58aa240c6b25360f5d5d0382bc03e5c22d33620"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "6774a7e1c0a0cadc0f903a09ca8b36b0a38e903f9d15020d5b8b93d1df235c5d"
    sha256                               arm64_ventura:  "9ef2a4a457757c7c449bb237a37a95a7630d561f5c50004aa64e961a2af99de5"
    sha256                               arm64_monterey: "5d9c6161259f4633a84a7e7a6f79f138b135ba1bc4d4541c65e1c8de8ac34f7a"
    sha256                               sonoma:         "7f381ba6da82ae0fed2080c7f4a227ce2e1ebce3f625ce3d34c6342cd18160b6"
    sha256                               ventura:        "e66ddd2c6d35faae1eb5a822bd4d2954297e103d99f952b721d5c51e50a5e849"
    sha256                               monterey:       "113a564f1b0d540d30c03dadbab42e1b506439ff0bec4f152b0ee68a3e8ecc6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9555e3692facfb3e69719e8b44676afa101bbf843bdf722acd74a01e80ce1779"
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