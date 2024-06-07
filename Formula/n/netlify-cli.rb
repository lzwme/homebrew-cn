require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.26.0.tgz"
  sha256 "307bcf7ee30726e9800e6f8086f8590c0529d4b19dda3e7929ecd60c540ba9c5"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "efde1e4e23098a8c9d637f292fff63378e66588da76d3a216261bf2abdfc4877"
    sha256                               arm64_ventura:  "f1a4c6af460ca479ff1a7aa5998ae38bf46b0d1ce2635e83537a6ad826a95f0f"
    sha256                               arm64_monterey: "c13419b99031ac6e22ad0de7d179fe0458ad6caf7a615d4527dc6075d693046d"
    sha256                               sonoma:         "fb81c7fa1f33b092f27d3f6546144499c7ed01c148a8eff9c7c4f29e7b636402"
    sha256                               ventura:        "62ee31d328a4643c7915c830b624942d1a24e967f46121e78242a7a0d0319985"
    sha256                               monterey:       "24aca2a6278e9b0e571f178e88c58e9a2d93cdd48c38b71406e7f6c45d7d9719"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d8aad8e812c8d558594e2456b7182844d2b8d90ebf7862f8f4e57afec564719"
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