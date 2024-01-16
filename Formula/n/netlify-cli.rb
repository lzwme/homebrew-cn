require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.14.0.tgz"
  sha256 "81e88ad1ff7dee8ce1adbbc38b8fbc97643f53cf900a397820ebdc248fb153ab"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "87715d05a27ee59cd9bbca0926eb75d201adef3f12af8d94ba7e9aa4a54c647e"
    sha256                               arm64_ventura:  "66c7cfce8376f1631b6864adbe12c86cdd031a0e54a50cf2ffd35b7194ba8f19"
    sha256                               arm64_monterey: "0dacbaaa6e6a8f933750ed9631ffb0a65d8250cdecf3a9a11f70c0673d2c50fe"
    sha256                               sonoma:         "056f321264ca42d6faf046285f676b4e8f05ce97471ad1d5d58a2b6d1121d6bd"
    sha256                               ventura:        "5e61fd1510f0a6c6dc88ccafefc0e9df3ff6dbf715d695104fadcaabfee3754a"
    sha256                               monterey:       "ac984f702a868691e7f0b8de532b9f8687b388c337c425523fb15fcb7ceb4bc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9f877a6a9817b6a3b5905dc1b302e3dad7a6d213e8bae90728c391c20094962"
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