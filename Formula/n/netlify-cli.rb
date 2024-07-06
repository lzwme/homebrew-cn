require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.33.0.tgz"
  sha256 "d9c64336c4d07c4909b2166c37e728e9edd15849630e5befdb745d30a8b6336a"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "231f964e9b2c3cad494db741ffff9f9c67605c1c6a9e062457f3b8bd99867417"
    sha256                               arm64_ventura:  "3ce4fa505a977c5f76d550728482d3fcb5df5b91bc8a94b0c7704981e8041806"
    sha256                               arm64_monterey: "d464f87ee47f756a84e87c67051813d1f96e4ffd4dcf34c3cfb5c52e32b8c299"
    sha256                               sonoma:         "d7bdb4e98001c22153f340beff70a7bd5f8c0d92754a3e675a1709f1b3576cf0"
    sha256                               ventura:        "c20abe3b1d04098021c97f2bba5cf44df80f4c78962bc033edfeec27f2eaa824"
    sha256                               monterey:       "8731f6b0d8f5d9a15b0f78b0d5fb80d056e29bfa78d6284034288896a71f54b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cf59384c8b6490603e3826f7b20070ebdf09844a3093923f5f01a00708cb973"
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