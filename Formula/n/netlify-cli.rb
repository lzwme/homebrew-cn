class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.33.5.tgz"
  sha256 "fa58bf9937752189129c88a576805b6ad13756beee12728569a9eb8261950a20"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    rebuild 1
    sha256                               arm64_sonoma:   "0a28426c6bd94f9258ce1b4c9f326dbdc8722f5ca514e4a0acb205d0cfd48298"
    sha256                               arm64_ventura:  "400d583e88d2d9ac4f4299ff15da9bed0c51fde70f4e377db82bcc768ae9d7b1"
    sha256                               arm64_monterey: "4da5b59329c4460e0f4002ec6fbb1c981b01f5f6ac6b654c378790a1daeddb70"
    sha256                               sonoma:         "d0f8420bc76e5563b470f3f712fbbfcaa2094b74d52370bb6e834addd3374e95"
    sha256                               ventura:        "2689f11e725eb46a74b20153a6a30128c23c550bcdda80f26d855c6eeb66e746"
    sha256                               monterey:       "58abe7e882e72f41f224f9af5cd3c01062ff083e0e8400abd14ee7fa57051537"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "792bc58bd646d500cb2e26bf96083c11a905de6317a92a7a9f35f119db45b936"
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