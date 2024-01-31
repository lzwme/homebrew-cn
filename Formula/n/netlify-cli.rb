require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.15.5.tgz"
  sha256 "c5fcd255ee79fb9fe07746f00a62961aab6972d462d33ec9d4f81a5f3c9f7ebf"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "a23f8c60627936e97613b4d69e33214b30ad6943c78e75e12001b451d51b800d"
    sha256                               arm64_ventura:  "c354042e18bb4135c8114be6fd1d5558535fdbd5b5a75db4b765a5f6a7845dec"
    sha256                               arm64_monterey: "794f3931c85cf6b84060f078e61c5f6b45e505d3a2d10100f115c55b579f21b4"
    sha256                               sonoma:         "1949527948e4b987151e994050ffcaade2e14d7be99ff12480b4468962504ed6"
    sha256                               ventura:        "bb77d4e02eeac42be704cc5b7f8bd7be6ad75d3cdb266e0dbbd09a9e86e737a3"
    sha256                               monterey:       "ca31b3f8cf1a715ab54f7b35170b0ac5093fbf5f59693282f67c955b14377e6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cdddd243b0cbb01893cab572bbcc6b7b057f682839e14e671bfbca410ac3beb"
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