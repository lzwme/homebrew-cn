require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.8.1.tgz"
  sha256 "238ab0344b75ea9d10bad477d0ccb9d199cb96c90fd383495a73009248d442b3"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "df864c20e7aff7bd752936adc632ec30b5bde542503db56d671e9e1b4b41cb31"
    sha256                               arm64_ventura:  "1a0b2f51746c555c53966f04799a53ca16873c7984ee4ae79d557be963edac04"
    sha256                               arm64_monterey: "4c1e107fea028d123250dc63f05b960a99e168dd0775d6a5d27f0a02007eb3aa"
    sha256                               sonoma:         "8f2311a511f0cd27cbe496633e84ddb52407e9569b402d906546972e4d1ddd41"
    sha256                               ventura:        "1b29b99943f798f7e4ab9b9c96e0caab038adccacbdceee6c045892a99ff74a0"
    sha256                               monterey:       "f5a566a3bed4db28fddb36f9977a712506b8cdba14d2946e22c9e82f3fd5cc37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4a83925480e7ae3c3fcc7a2385207a2ceb933ab1787758c09403d4f21e16f64"
  end

  depends_on "node"

  on_linux do
    depends_on "vips"
    depends_on "xsel"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/netlify-cli/node_modules"

    if OS.linux?
      (node_modules/"@lmdb/lmdb-linux-x64").glob("*.musl.node").map(&:unlink)
      (node_modules/"@msgpackr-extract/msgpackr-extract-linux-x64").glob("*.musl.node").map(&:unlink)
      (node_modules/"@parcel/watcher-linux-x64-musl/watcher.node").unlink
    end

    clipboardy_fallbacks_dir = node_modules/"clipboardy/fallbacks"
    clipboardy_fallbacks_dir.rmtree # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end