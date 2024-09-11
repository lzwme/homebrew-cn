class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.36.0.tgz"
  sha256 "4e92bf7dc9b283ed390e2c47ace521ce293b9479bfbc4652802b57b54c53fec1"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia:  "29fdf6b226c4444196e83cfd0ea3ecafd1e709bec64b29b1ac6fdf9044edbd29"
    sha256                               arm64_sonoma:   "f6f61d162844a68b7e95f07cf4bbf92c218f9bb37a506e8350c887cf3ad0735f"
    sha256                               arm64_ventura:  "a5558c75f90b40b411af5d3b8da1f4570351ae70299187b533d12568bffe54b0"
    sha256                               arm64_monterey: "89fa3d32f6dcc693e8ec928542fb616f2f51dc2bb4968cfa8521e0e51167d09f"
    sha256                               sonoma:         "6d3687a58ba5b7c0285c720d804533da890743e4822746d35625f2b09c07015d"
    sha256                               ventura:        "bba4d01c98af91a74e7f89901c8deb6fc9fcf91c7e49bd95ac36f34547c729d6"
    sha256                               monterey:       "036b5e1dae1d3594de5c24cdf12c978185a818da04665e77aea581aa6bc9208b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87cd6d3dd1b97dde00cdc0953d3b07581942d9e0bf4d42466d684b5cfc5dd030"
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