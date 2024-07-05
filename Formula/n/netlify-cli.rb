require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.32.1.tgz"
  sha256 "c435403dba9419db41bede03fe3a3cb45c3fa13f51ecfe2e2ed3408d4d390691"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "bed1226fe77b963e2dc63c2759d8ff3ed17090b3592eea5bc5a31cc45fc91d3a"
    sha256                               arm64_ventura:  "5711a55cc0f8353889975c6097c083fb5395a1ed87b7a5223e15c39a778335d9"
    sha256                               arm64_monterey: "c6d84caf2c35454e8be319b737a4525ece2da528bb06155899dcc4977d74f6a0"
    sha256                               sonoma:         "f37cb16f7cad43af725a9509c57098aa9874aa9cbfe077fbe17efebbf93ad2ca"
    sha256                               ventura:        "67a7c1973c72eaf88fd34892118f751535c0f582d0b461ce8892bf60dbb0ec48"
    sha256                               monterey:       "f1b8eda4df9fc5b0d0685a8c13e0767dee5a177a57ac2018ad61e67eb1aa4be1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78664c99226fed435553bf6139b7a28f5065131fbce085c85eb766bd461c632c"
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