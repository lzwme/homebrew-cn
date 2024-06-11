require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.26.2.tgz"
  sha256 "56568bdefc2cadf4f08616472e82171b83b0aa95210c10840fe2806e44f5fa0a"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "eb2194fe76099a30dd0412f96460f4f3bdb866019e960816a925997be6661ca2"
    sha256                               arm64_ventura:  "d41e0d1335d5a8d41898f3bea75de0678e38de8d9a4215cc33c2d8be72f7c404"
    sha256                               arm64_monterey: "c69ee929f3da20f9d022fc8306e9e6dac639acb8ae3eb1925fc565d2fbe6f7aa"
    sha256                               sonoma:         "3fbfd0c32bbfdef529be62bdc69726047f3d744bf063ed410a226d44ca332b4e"
    sha256                               ventura:        "8c134b5d5070d2bc83e212815d19e9adbbbfdab50ee9c131efa33f81e8fccb5e"
    sha256                               monterey:       "0ab5a24eae21eab97615681e4b32d16336125aa154b78e2cd989e5beca117b59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2289d1d72838c194a45e852182106874c5304ef66fc40ece3c316eedf9dccc3"
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