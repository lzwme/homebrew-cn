class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.38.0.tgz"
  sha256 "3fae47e1eb3572918f9ff90471c3a18e391f6fdcd3878352fec6a229162b7b66"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "2c88462112d4d62a45a3a152823f308294fdbd43ea4a7150b6899205ccc94a93"
    sha256                               arm64_sonoma:  "7a5e3f7b820143f7d48cc0e983b02eaace099faec197270a7b28f4ba1d24db70"
    sha256                               arm64_ventura: "ebfaa9d4464c156dcb6041fc795cf850a9d17f77644059161cd8d571f642b145"
    sha256                               sonoma:        "f75796234e929cf3e053cfe4396c95a80aa56a6b22decef321d36f9f888cf080"
    sha256                               ventura:       "6c84e69da78b3c2641cfb3d3bfa9046bad7cb118e7fd7be85410967d6ef558bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cacbb8cc77727f007cce730474e7c96ec923a5d93c719a5de9ef8f921295fa4"
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