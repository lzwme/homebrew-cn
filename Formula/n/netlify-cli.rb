class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-18.0.4.tgz"
  sha256 "8a103d9b3f264b99aa62222a6d400a68e668f7345f4df03da08cded1ea360c31"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "b1657b938fb778ed600e62b7301d54212e6edf00a92fa59d114323f7676461d0"
    sha256                               arm64_sonoma:  "ed64cd1131941f6a79557be59d1f09e115d6186a6a54bf9472602fdc1359584e"
    sha256                               arm64_ventura: "d17a679680c4006205a0c9379362de266e8568a7da7359c5e45c85afbc1cf629"
    sha256                               sonoma:        "f18de5f883892d35e79e06dbf092380307b3c2ea14a7fb4fc7619837efdb9129"
    sha256                               ventura:       "d799feb6b2e8852f6822c248c040f0511a8398472cdc9b9b56d511483d5e9e76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f7f963448bde2b43ef4e70b00f0c03688eb99be9fb236049cd73dd44488537b"
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