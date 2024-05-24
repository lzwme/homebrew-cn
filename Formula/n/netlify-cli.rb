require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.23.6.tgz"
  sha256 "9664d091b193a0d8ce317d8ca087924d872c924c9d2d03f8f4560cc5766c3430"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "a99823602bfcbc05b5ec6f4a75dd6e9efba4bbe039d18eff995493c865eee56b"
    sha256                               arm64_ventura:  "bc276601ddf8d3c44f829ec43f02e6cc6d575673dbaacb8e26cea90eaeecbf52"
    sha256                               arm64_monterey: "7853572399a408577aee3cd9ff9f178d94029f27e98e79cfcbb6253417c9edc1"
    sha256                               sonoma:         "e386855ce148d9ae89f5cf70726df04a3769d5b47ed0c4ea8b080d1eddd110ea"
    sha256                               ventura:        "a4a8e0377161f2a5fbab2639f46d53bf35631ceb5d54021df782948863559ee2"
    sha256                               monterey:       "7b0fc021bd6eceaf07a7e62d68fb185308068406c96d5258482483016bcd74a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83d5de3978a8e820430bd38f102988b5ef94a587cdc037f815c35497a7821d8d"
  end

  depends_on "node"

  on_linux do
    depends_on "glib"
    depends_on "gmp"
    depends_on "vips"
    depends_on "xsel"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]

    # Remove incompatible pre-built binaries
    node_modules = libexec"libnode_modulesnetlify-clinode_modules"

    if OS.linux?
      (node_modules"@lmdblmdb-linux-x64").glob("*.musl.node").map(&:unlink)
      (node_modules"@msgpackr-extractmsgpackr-extract-linux-x64").glob("*.musl.node").map(&:unlink)
    end

    clipboardy_fallbacks_dir = node_modules"clipboardyfallbacks"
    clipboardy_fallbacks_dir.rmtree # remove pre-built binaries
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
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}netlify status")
  end
end