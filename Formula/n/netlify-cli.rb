require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.16.0.tgz"
  sha256 "07837440a7b0db39bf7d56b9886ea322fce8ac12e6fa759ceeb3de58f26abd13"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "ff1cf0e706a7a6c737683699e0f6860f0c2f0dfcfbdf4a9771cd06b669892f06"
    sha256                               arm64_ventura:  "c7d91d0e47f80313e17b43c66be77380da71dc64bc5012e31571758e9f23b4ef"
    sha256                               arm64_monterey: "c63165b44def3258a25c24368e03d737d3db3a9a09a19f0ddc878d95427bdb08"
    sha256                               sonoma:         "8eecfbdfa4c7de4baea0735027303d1b9376049f0f1610c898b985e33bcdce3b"
    sha256                               ventura:        "47152d8b9b093b796efbf73f73e82e79f368a2147b418109982e7a32834e15e2"
    sha256                               monterey:       "862b9a9a11819e8edd443d5052908c5718246c9e87cba9351b3965a0437a98c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96d30692ea6b57531460509e8a73c27a6eb797310409ca8308c1afd7ef66727a"
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
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}netlify status")
  end
end