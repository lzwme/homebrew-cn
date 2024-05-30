require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.25.0.tgz"
  sha256 "376be58b2cb811399b8f113656c2127f47001a91c1ba1d2ce76c9bac51752ebb"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "761c1731f812d32a559b8666bd3cfa796b3de55789b82e9015d53827384724e5"
    sha256                               arm64_ventura:  "1de96a814d0d2cf14ce262115a8d8229057082615f338143b9510b9045432caf"
    sha256                               arm64_monterey: "1555e2670d2e90168d695c361ec9ecc83a55cf6636be1282749b48e45825c2c0"
    sha256                               sonoma:         "d06f262ad618b736b2126dfd7638a8a8aab4954a5182344cb948b092853f06ee"
    sha256                               ventura:        "2adae6b145ca304027447e8c17d972157fb1df3ff2549c4ae1f06627e462d9d8"
    sha256                               monterey:       "7146f5cbe5ba301f4044a06cd4c3284d410ac78a6b2aec327e5398bfe93411d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90b562858286cda1c0bdeaf69a679c5a6ac888f3a8dca48a4c146653a189a267"
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