class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.36.3.tgz"
  sha256 "55851a9ad75ece79a19f69eeaafa18503efd7e36fb1a69b92ae9c320e12100f0"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "b04b4d272c3f61b07ec5e2a3d1df28b657e9306e417f504724ef538ba98417ec"
    sha256                               arm64_sonoma:  "8f1826c4e8f7d4153b776b9198c37990c4cfe2ced0f308c2b06c0f94577a3f96"
    sha256                               arm64_ventura: "6503c35c0ae121fc39c77c153998db127074815c03656efb2f6f0504823df8ba"
    sha256                               sonoma:        "8709f48ffdd772e3667e9708bc7e8e7dc576ad7a06ad1559d3496f427f1b00a9"
    sha256                               ventura:       "865469cb99261e10cbf78deb2efe8f788e2f84c9ae550a85c6e8bea2d6828b1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0047bf761e1df3edfc579eeddb4a361ce12284ffbb0e14ebae4306e22c20b9dd"
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