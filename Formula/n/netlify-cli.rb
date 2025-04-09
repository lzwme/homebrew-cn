class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-19.1.7.tgz"
  sha256 "94e2108097d5db9709a45dfeb94bbf5782a7af40812264e58868edef67c3a7f0"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "80f58a3161437cf15da8bc9feba5dfe75a2d9c5a7af0fbe18e412d25f14b7a9d"
    sha256                               arm64_sonoma:  "e7385cf93c28a800efb4b857143cbca729df33129de97e7cf79e7598e0ea69f8"
    sha256                               arm64_ventura: "1785ccf4cd0c32d0659ab9c4e7c7a4532fd4d449311cd7ca07e30e6887df61be"
    sha256                               sonoma:        "885b6fb8a17c244416777c841df5213c22567278ce7f6533f5e6eab7b269fff6"
    sha256                               ventura:       "6c7c3cd266984fbab25af6a2482f1d6ab4f3d45ae7fad954cf5c855383330c0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b859760846ff6ed260a46275651ec0ade8e8f3ae2eec52e3ccc6c62067f353cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca235a164ec99c142d84de4571dec42809a84eacc6018b53e8bb79324cc9302e"
  end

  depends_on "node"

  on_linux do
    depends_on "glib"
    depends_on "gmp"
    depends_on "vips"
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin*")

    # Remove incompatible pre-built binaries
    node_modules = libexec"libnode_modulesnetlify-clinode_modules"

    if OS.linux?
      (node_modules"@lmdblmdb-linux-x64").glob("*.musl.node").map(&:unlink)
      (node_modules"@msgpackr-extractmsgpackr-extract-linux-x64").glob("*.musl.node").map(&:unlink)
    end

    clipboardy_fallbacks_dir = node_modules"clipboardyfallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
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
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}netlify status")
  end
end