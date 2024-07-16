require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.33.4.tgz"
  sha256 "b20d3925d343a280e47eb7ebbcc3894264d586ba504a8a99046757ec0c48eeda"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "2c387866ea3da1b8f30392e86324d582acb522f563e750ede016b6115af924d1"
    sha256                               arm64_ventura:  "bb8c59d1c790e401b6eee5e677c5f3b60a415fba0c1cfb7d478d77d49ed69176"
    sha256                               arm64_monterey: "0ac6663f420712f97c70584c6c72b2fbf5a594603b8cf014565513014399b259"
    sha256                               sonoma:         "90feea61f80674498d185ad088480cdeba187a05ef8fa05cd01fe35f27442c24"
    sha256                               ventura:        "05f626c65b6d690dff3f319d760f3de01a1c9751235caea6f376b2df9891c6b7"
    sha256                               monterey:       "3dd0304857d672bc2dcc02ffe19e71af02163be8f73f6697ebb5ba85ced971a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45a8f736673212d019102597ec5e32389ba65d4c59bda29a297fcda4f3efd4b3"
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