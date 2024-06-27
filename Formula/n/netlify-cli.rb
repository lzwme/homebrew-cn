require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.30.0.tgz"
  sha256 "77131fe63ebc58961a1efd68978d121103152d175757ed290c2b737dfaaadc2d"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "14335e6ef9fcbee08a69e56f53f34012be30adc66743b08737f01c5108e52520"
    sha256                               arm64_ventura:  "99e09cb27a52841d26179cf9a7d63f2b7db905d7fe5e314308cdcb900af0194c"
    sha256                               arm64_monterey: "2fa54b6dc7238dd9576e816872fe4588e45494eeff3751e743ca353467216e8d"
    sha256                               sonoma:         "4e4053bc27a9a72a28d89dff117611319b0f517b6d2afe9a0f64cf8c13142e86"
    sha256                               ventura:        "cf52c5b2d0fbabcae33cb185b258c3196d4f07af571d6d34f9d506f1a6d30b7d"
    sha256                               monterey:       "4772013679ae6ff3a3801c0c785d03a12fca69c453fc0518eafaf113fbc12c6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77b497212cc4b2f97918cb91ca1fbe04bf84343b906903cf3d5ce44faf631cec"
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