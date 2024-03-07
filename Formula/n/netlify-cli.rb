require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.18.1.tgz"
  sha256 "38dfc69f6620e1bfd5a7b0236fe5a801b893171790cee5b898a15f3a819cb1e1"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "735d87ff98e8f55b96ab40b74627fc0a70a16d93c2be2a5939547b61615806f4"
    sha256                               arm64_ventura:  "d0ce2a0c9c0669edbaa0f2486ccf84edda6d87896da1934f53757fd5a9b25f24"
    sha256                               arm64_monterey: "7dcfa8cdba94af96aa3402faf14f6c3b2d76b8d475398bc0c795a03bbd737c67"
    sha256                               sonoma:         "baa6e000e08d513fd4d4c60de5aca8d028a39b62cbe518d7c9a9f2c517d5f1e3"
    sha256                               ventura:        "b2118a915492f285f309a4fb7560a44597b0127dd70477291221586e0464480c"
    sha256                               monterey:       "77e4658a2e37701a2d93cb6b942cf7766a07075b86b12343c60388070da30e36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8322df217ac0df06552b97cb6eb298b212fa7a0526331668324099e694dac031"
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