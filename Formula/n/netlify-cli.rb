require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.32.0.tgz"
  sha256 "3d316e23175a161aa29d4f9cb12c76b961dff020f52d9bdf6f8def1d7f0c2d4d"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "01d624d236f7ac1bbcdc973f85df242d0a449cb642c8958321a54fcf1d5a4c3f"
    sha256                               arm64_ventura:  "7a17ada911a91425f3e096ecd772c90a8273a087047400b08f9d15aa8f3d749c"
    sha256                               arm64_monterey: "1c6eccfa43f242681e73b7ff43d7565f2eea7533c8e3de150bc333059e688614"
    sha256                               sonoma:         "e53e08054930d6644d2985dfbcfe361cf8320cc1fbd41fe136dc2cea3a01f5dd"
    sha256                               ventura:        "6861edcad6e9f4b278259969d109e3f792f9a81e9305eaf77acc888ab94d6c21"
    sha256                               monterey:       "c92902c6054b66ae6bbf91c4694c5bfe58eba4f4b8416e0f2dababa82d0bc5a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9236b30995daf9f5708c49383a94bb0b61ae9d39107350de8524206edcbe8ea"
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