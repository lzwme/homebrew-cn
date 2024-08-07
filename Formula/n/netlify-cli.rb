class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.33.6.tgz"
  sha256 "1261d765d0f8220919ffd84a21fb6a54667bcf7c1bd364eabb541d7f0c3af196"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "c9bbef41df059a512181c5002504a01bdd036cc2790c92466d9f34a47cee0ff2"
    sha256                               arm64_ventura:  "0772528d6f5501d8dffcffb77e9c918dbe259b7a29e0a3cd5d56069735f6d2d8"
    sha256                               arm64_monterey: "61f8f2c0989ec249a2457358a7ddeaaaf351435dd1baaf075d5590583774bcbb"
    sha256                               sonoma:         "433e4e61f46c4b3f2c8418e9297e5e2717f9dfcd8f4a82a352601ed49cf67555"
    sha256                               ventura:        "157712d19e5f0aebea92ec0b32836900210af64cbd4d7d5d2a0fbb220722c599"
    sha256                               monterey:       "be9cebe336b5f98203014af4b6c0d0774c95b76dadc59c350ab6dcd50c512524"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c21baa2b80f44406cc5d9e80855254941a35cc327d9e1390f1599af6e53a17d"
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