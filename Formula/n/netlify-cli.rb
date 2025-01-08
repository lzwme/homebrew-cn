class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-18.0.0.tgz"
  sha256 "1be6ee2ff2381306b69930fb06fbb54ff06d779fc7bc752f6f119aa0e9d2269e"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "e767a2ea44b46c6d56b7482dd59c38133f4a8ae24e5ff6fd1af022609abeae85"
    sha256                               arm64_sonoma:  "9526180c5202d75149753bb20e773c42f5367532261e5f70070716b2e0883b4f"
    sha256                               arm64_ventura: "452d1cb8ee8ea16684f89bd0f6438236c7569a9ee0da7976c339943ce7c8f6b3"
    sha256                               sonoma:        "cf82dbc3adb9e22eaffcdb16375f9a38afc4033c1cd1413b236f4098efd3e5c1"
    sha256                               ventura:       "dc099c85d762ff060a6605aacf659dbe2c194d88363680386291f0a1f04a87e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d57629dcbe27a46344305116873f3926080a3f7d3256d170395c7824da998eb1"
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