require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.16.4.tgz"
  sha256 "7b45fe8e98c80a2246a7de635a7ab1ec3073ed36675bfe8f840126315d0d905e"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "89d68b747b8ee117ebf53de059872555fa92147b26b3bcf02142902c9902059d"
    sha256                               arm64_ventura:  "d1ac381218b26d7ace6b96a8d7a92e64290c821195cfd36a781bff672c41d836"
    sha256                               arm64_monterey: "66a39d2d592272069ee29891ec6eb341b8cd94c231a023c3e8488623b40b0603"
    sha256                               sonoma:         "bdc3b3c0b96eb470eb9d1faf0dd2b4f1b280cc4385ea5fd6620cda5488bba56b"
    sha256                               ventura:        "d8a6202a058722bc73276a0d13d177c11c11128dbda5f85f0c46c029647fb75e"
    sha256                               monterey:       "aa9e4307de008154f31c80618b35070f060276399a34d52c516f507d1d0d50dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04c2cf4d05940c4277f382a8bd4c9500539b45f4af69759640b0b0a18136ca9d"
  end

  depends_on "node"

  on_linux do
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
      (node_modules"@parcelwatcher-linux-x64-muslwatcher.node").unlink
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