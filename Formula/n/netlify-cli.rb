require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.15.3.tgz"
  sha256 "203fb5d98c6b407902a71d595d8414a584aec04fa109f68a980d1483a7612ab7"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "cbf35ddf80c1360ae193b63a6d29429b38dc19479d7c9a90e457e5897dd29980"
    sha256                               arm64_ventura:  "f0e94f72d42a38d76a0bd5357ca11b963247d455ab3f6cb9c21457bff39ddd19"
    sha256                               arm64_monterey: "027e98b02fc4bbb24377962843f9e31329b1d2cb7dcd19de07062fd747f51e94"
    sha256                               sonoma:         "0607ec9dbddcade4beacdd8596f02b0d72987fffa2a6f3ad9be21cae7c7ee1e4"
    sha256                               ventura:        "3d23e184bdbc05b7ec73532a266347ed982dc995f87b10985461fc22322ef6e0"
    sha256                               monterey:       "5eafd1a946e677848464f60d32ccc36f334454fb853a38056cd4a5eb4db673f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c64a64d46ba7275c7c60a24d3f0f5706e21d72e7b302035c8a58e2cec995f5c7"
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
      (node_modules"@parcelwatcher-linux-x64-muslwatcher.node").unlink
    end

    clipboardy_fallbacks_dir = node_modules"clipboardyfallbacks"
    clipboardy_fallbacks_dir.rmtree # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}netlify status")
  end
end