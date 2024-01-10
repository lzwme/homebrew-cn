require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.13.0.tgz"
  sha256 "74ba180f24c3fb29a37a58a5beb8247c17104cad5e3abac8cac18c4be8430fb9"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "9add384f51c938585fd524d1b9597a39103998bf08884f11fc4884d2d6ccd6f0"
    sha256                               arm64_ventura:  "5f54785ace3345c2bb0ce90d94ad758d304887907931ec29bc0ac1461dc28af9"
    sha256                               arm64_monterey: "0699d0bf8f701e5758fd49c3c674f5dbe0dfd8e16574d1d35ce8e8b7bb44288a"
    sha256                               sonoma:         "97aa0af3cd6c8a1fe4b649f3e5801ba12a6b6b07412bbc6de221ce479bda9deb"
    sha256                               ventura:        "3228b5537599e284da4d16c5f62076689545da35ad2fdab2c5174cbe3bc79494"
    sha256                               monterey:       "d505ff42dc2ea4787d941661de6db052c66c9fdd7b3d4a412fcd4d4829de5df9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fb43f6e84e5651d96854367eeca27fdfb4400a4a300e204b63119c196b8ec45"
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