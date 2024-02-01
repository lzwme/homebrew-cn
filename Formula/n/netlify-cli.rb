require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.15.6.tgz"
  sha256 "ee9fa60fca7b3e03855123bf1949009561548739beab449431af5962a41573fe"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "5eb9531a2922d7a76a0009a221b31c683cba6cfaee6e1591f3b00f5553479490"
    sha256                               arm64_ventura:  "1a9106cae20b4980e57401a803314dd6f5613fafab1cc45c1a8daeaa8bf56dd8"
    sha256                               arm64_monterey: "a11980329123860794f32000fdcb03e20305166987c813c87f7c1d330b60a5a8"
    sha256                               sonoma:         "6fa98909ab609bd02ce87235c9abd36c628a30e071d2c2c39d70b5877d24510a"
    sha256                               ventura:        "8d161d5ae938a163f6bb52ee059d65bf17e38ec40a73652008620a64a94aa433"
    sha256                               monterey:       "adbe5b4ee1f69a1b84330ab34a2dcdfd13232cb042ebaf67195e494f8ae88432"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "960bb7db7e221efa234fcc5a73ee8a35ecfb69e70cda0b23cfab7b86a6cf659d"
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