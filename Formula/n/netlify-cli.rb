require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.15.0.tgz"
  sha256 "528c1cfbc9a277d30dede73a858a133c688badc413686e608302ac27c6689162"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "ab5ef84d873304951d2da99c4df08a09d087811310e1b25550fb73a852b51885"
    sha256                               arm64_ventura:  "520a065fa00c2802e28b719ed8d86d16b0c3949d26df20d865d5ba2457bb3630"
    sha256                               arm64_monterey: "7fc1ea3983b7b50251b7ff5d45a3e61ebcc559fd2c3b0c3a92d821c98838843b"
    sha256                               sonoma:         "55cf00437cf39c03bf920ced251b51620be650f761f7c02d59d956ec4f972a36"
    sha256                               ventura:        "62e7f1c308e538cb210fe964401c72cf96d7b7c7f85e8baa688216a41409afdf"
    sha256                               monterey:       "b75a1fe9a8da069a3686064a5e9cfb942d066ca1b0696b1711de34fa8660c641"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c59ff54d1ac27c8d4fccfcc0f0c0a98818b28c2b0e4dce4935d713dd32407ff0"
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