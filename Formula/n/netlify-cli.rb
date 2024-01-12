require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.13.1.tgz"
  sha256 "546388c3775955aff65446abd5ef2613c876256316c670cc667b9337dde76844"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "576f1f1792ecf365543725d19c22c36b386fe23564c8a2fb470b179444ca1819"
    sha256                               arm64_ventura:  "6b634f7905a9c7641ffa472ce4ec07f6baa60d62b74327ffcc607a40048b1cd6"
    sha256                               arm64_monterey: "80ce87ef394219685ec0f338fb50011e034baef500bb172ba40d1d155a0498da"
    sha256                               sonoma:         "49ecfe409d06dd5527be8f9d42413b4a59d969e21dcab8bc28e304ad59bed289"
    sha256                               ventura:        "670c099320f09f29c4fd8a90d01c453b5936acdd43c50abecd43e4d974791044"
    sha256                               monterey:       "15db403c36c905e981e414d069117dce4d27fdd71a8c6c4de97eb99ba46e707b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a3930e2ce227f33827ca5d783ed56ba006cb9d17030134225c7cbdc99c6dfac"
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