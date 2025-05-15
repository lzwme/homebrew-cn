class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-21.4.1.tgz"
  sha256 "0956ccb01d1e591f944f01978916b00676ee3d4d70ce2a694eeeb587dc8f2acb"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "0d2555c89063b5de3b8c06267b18f9a8257d375caffd1babd9f65a5813a0b8f7"
    sha256                               arm64_sonoma:  "24c6453dec65918c6d227dd163a2f302bda9e0d92d3874d249be25fcbe667c6d"
    sha256                               arm64_ventura: "8f91e53354f0470061394ea960809ee2c39298a8b1e5f708deb7d532705cab68"
    sha256                               sonoma:        "2e192d9e01bd31655ba53be94736fe33c1df4971f380ab713a6bd0739383db5b"
    sha256                               ventura:       "3d3e3b98aaed6b314664f4566abf56dafa48edfaa5449c318cf4a1762a4298e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bfafbc26a89825fcf77dbff967f18db6c1fd967b6e7179a1d71649a92e391ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f19943fe6cc06e501eeaca07bda02213763f0fa23dd6d951c51c4346cd92592"
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