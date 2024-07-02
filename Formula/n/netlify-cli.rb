require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.31.0.tgz"
  sha256 "d7a0dcedc2384cd0ae28d7332c17cce9ccb0a485b8a4531e005d16232f717e81"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "f9dd699c15d4fec9a8a80a00b811cad025a690258343a4669c8db87ad618f293"
    sha256                               arm64_ventura:  "a20c4a6eec5c3f20a8007d8afe018759d429b60939e225816f43e9afe227701b"
    sha256                               arm64_monterey: "0adb17a6ffb6038482bc47c037f4d2b4c4a8aa277af4ecf8e428684e5aa39043"
    sha256                               sonoma:         "d2b3393cb7e18fda52af9451890d1acef7ebf998849b38ceaa0abb000c5c8597"
    sha256                               ventura:        "ad66c696ac783c9d2e5b3361dd152eace4de5336d407b9bb9d7ea8d56a731e1d"
    sha256                               monterey:       "c0ed0d7aaf8d24a281eb4f64eca9b945419fab33fe40f8d37b6967c2857ca6c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7da000c7788017d4c3a7db885a6b67da9e1746a4fbf0940a157f4bd887bec263"
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