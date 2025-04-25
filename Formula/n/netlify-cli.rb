class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-20.0.4.tgz"
  sha256 "fab7d8ecb6040f3574fe5634f82fce5ae53b9d6cc818f2077dad73c781f1941e"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "11bb72002de1e03a423ad733037ce278043e8dae3efc5cb66eb2266e0f62fcc1"
    sha256                               arm64_sonoma:  "38cd39df3af546ed599315da43d10889f78391de799e6bf94a57f23abb7a2ac6"
    sha256                               arm64_ventura: "65b57608a5955342eaf2bf6aa3c216a0b7ca6141671eb836050270957fe0329b"
    sha256                               sonoma:        "09036cf1c2b4b83d7d65dce44df46ea7241594eedf629d0d5b163a26d83e8d10"
    sha256                               ventura:       "79014010e59f79b7357443a475bf3c7c388fb3c7e7fb37a3d1e822d74f861144"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6db6a2061e1c5e1479da83d5c96d5de0ae17f71aabb53b580132c92917aebbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7085b9bbaed157a5124404d2342081b296171a4e6ac4adf9dc33c3d26815b78"
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