require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.10.1.tgz"
  sha256 "432134495a73804a82fbfa396342041b97856af30df11415bbfd337d3054d99d"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "2a41b357335991befed43e7239289aa44994b66cbc781eef143b6f5fac516629"
    sha256                               arm64_ventura:  "1b3745157fb84a51cf21f4eb4c86cd9b237ed02cfeb0eb5776c263e4609a526e"
    sha256                               arm64_monterey: "2e1067db420af8cc7eee06a4994999521c87e072218e7a39e92becd6e9c02476"
    sha256                               sonoma:         "c62dff938577e60b57353580cc3f4834c1a450561ac527011d1eb95b61ee3069"
    sha256                               ventura:        "29107d1fe1d2eae82e775442cc68fa2a86ade2674e780aaf8bdc49cfa8cabc93"
    sha256                               monterey:       "533f590ce7a0868b2a73f3337ac26ced8a8daa58053a7045474d6d18e9b05f66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3c05c864627260069b0e82777ecbe66c9c5e47af4222479d6db1719edf370c8"
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