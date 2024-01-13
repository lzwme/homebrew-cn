require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.13.2.tgz"
  sha256 "776c3a1f10e46b012ef52919aec7f74d972285cf361aacf2829f0bfbb61b9b90"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "3cb4ae96e66555cf291298230e6b00fd464cdfa398c41ad85ae90846714babd0"
    sha256                               arm64_ventura:  "a567c03834367d53575ea7a0cc74ce2d638918a1278625cf48cbc654ad1b6d7a"
    sha256                               arm64_monterey: "e2542550ac3c830f9f29c1f2cbedb49f6c0da51542ee3ad945d1ff8e409df72c"
    sha256                               sonoma:         "776ef719688066fc054bd6d251a080b6e0feaa9be9a451dd555f20808cebe04f"
    sha256                               ventura:        "5fd27ba487e123e59b17892bd9806cc9482134ca78b0fd9dd9b1f7d509c96084"
    sha256                               monterey:       "a200e575eeebccb9623ad64255cca7be3164c83de35ceb412defef0e6274122f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d20199c9112dd3f8b4c6912797cd6215135e21ba80937758b49b4a1337680ce8"
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