require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.16.3.tgz"
  sha256 "b1988d63f71858b8b78724c4ea438d86c7f23127818d9957dbf95eb1e3792786"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "8be18051c221f4cab57d44d26955836f40c698dcd7245f84cd5b3b56e9786242"
    sha256                               arm64_ventura:  "0e8515032048ebe34eb72516d96bb7e9253dfb4bbb1b1cc0e9f5c7a7e9db3543"
    sha256                               arm64_monterey: "404e5ac6bea91a6b422c250d293f3bf13222f298e56f2776b7f4a1b44cc7b253"
    sha256                               sonoma:         "9dc74dc55d5f0621233a34ad0972b480a093ce297faf7f4baa67cadf0b7ef085"
    sha256                               ventura:        "fee7992fb6ad6a8d706a44bb04f7a497a14bc1c2aabfaaaa78fcf4c735cc6a92"
    sha256                               monterey:       "cad8fd2f147b122b01dbde4e07a4dd03f44c8294906383c35ed0796ae9098396"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91c71dc4db8f935eefc53c5bd569e667783ba27c1ded07aa604065247101f02b"
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