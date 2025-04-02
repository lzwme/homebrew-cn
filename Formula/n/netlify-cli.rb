class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-19.1.5.tgz"
  sha256 "010c1a12ed2834e2838ffb9847e4493ebe112bbacde6a6a709df22b094aa6852"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "c19758d8e68480a2ae6bd7f25c5b6ece2367b25209eefc5a580d653a294bfbac"
    sha256                               arm64_sonoma:  "2c70edc1c565e9895f06649cd7b4a05a0ccc7c7a31578b451eae91798d5d6acc"
    sha256                               arm64_ventura: "07ba802c1cceeda2363e36812ebe8029dfa57f380fd93d6928685eb85929e6c7"
    sha256                               sonoma:        "69ce4c66baf5ecfe96c9053c88844d54d8d2e406f3179d5a35dd08c0ef063a26"
    sha256                               ventura:       "421877f4bf6e3a12d727a8748befc0c8a4b5cbaed6fd3df420cc6f9af52f8ee9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f90e96c93cba85c9a7ebd983855594df35f8277180033843d14e3c383ebfceb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e920549abe14634c142cd93aa2c71dfa33ef26c0bc7e5b6680675765d3e21f3a"
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