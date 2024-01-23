require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.15.2.tgz"
  sha256 "922bc7b07170cf30aeca6649ba267770624ccbd67a6796043a2450b3ac8e2f85"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "405982614991b5de906839a46b7a32ef1618c01e9a88d822f415865e42941f28"
    sha256                               arm64_ventura:  "231629a7bc13549fd76a5375151d2ed4ca8f068da5b597f2b58bbc43534c5605"
    sha256                               arm64_monterey: "54d303d59b2292c67f614a80c493a8d45dcf65489a7d6774a9341ab7ac92e7a7"
    sha256                               sonoma:         "a860717feae9da89f7c02319d8c5c03bc78e136d029012ce4ad9429e5bef3047"
    sha256                               ventura:        "c1524d13cc73ad186e37d49b44c2fd2e060efb872606e12a56bcdea6d8640193"
    sha256                               monterey:       "de04933427882c68d55c81fab2707a36f9c01cf8558ba3186cb29573d2db153d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd8bd6a79fef2819feed8898527a701348c2e1ce30bf39ce38df7e309af887bd"
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