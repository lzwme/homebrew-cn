class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-21.2.0.tgz"
  sha256 "9a237e7f6fca419dfc7cc42ed34d15927d82a8a0970ceaa165ffac34c46f0608"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "2308423d95f0a4a9e7a0104d632b8ef7c72038f7289235a1a689bbf9beb93f1a"
    sha256                               arm64_sonoma:  "8b8ac1e591db37fdc6d9071c56492a8ceca5882808dfb75b6ab04db1cb8c583e"
    sha256                               arm64_ventura: "42f90b1c18c524ffdb52239bdd3e8b853b63fabefb19597980866acc6e7c407c"
    sha256                               sonoma:        "f9c2bc6e7e3b45ccf7d98d2594669f3a417dfec33310cf8c70a2fe020fd7b6c3"
    sha256                               ventura:       "ea9fe66b51f6bae259d99b332c5a86ab59ce57a8f7bae2666688582f503fa8e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72f97a34bd0c6469c954245a6f2863e03a5c6fa988061968ccc4e91670c2df51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5250f698335c03018e8643fc82d00f0d969d92b8cff740e23ae5a383d11a255b"
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