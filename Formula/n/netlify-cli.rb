require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.33.2.tgz"
  sha256 "8b9bf9661b1f1eeb76044d6016c1ef8399ef0bf4704090a2d380aa4a4ccedd1f"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "e191e24224e81778748f20a95ed9978c5d3b6b9d41908860dcc899401bacb111"
    sha256                               arm64_ventura:  "db3044153ba86f84378a52050b79e1dfbc169f6194dc6435839cd369ce189f09"
    sha256                               arm64_monterey: "99060e3e4ea3f3be0691f38a26ddf519af80ba2f2330bb31fb90568132dedbd7"
    sha256                               sonoma:         "d09f11976c956cd9b8edd691d367bc035c7eaded9b38d3dc0f0f80d7970e6975"
    sha256                               ventura:        "e3ec94411ba9204810ec4e071b86228b005ededf0011d30f01188b297ca6df82"
    sha256                               monterey:       "a9cdf21b33e9628f80cc9ea55c7fe24a50bc79f73c72e7fd9359b6b49d39cb3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63108448507d00e6391bb649bdaa79dedcb0c4cedb7c9459062b4951edad1d11"
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