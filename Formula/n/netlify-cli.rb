require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-17.3.1.tgz"
  sha256 "1ad4fbdf71b832cf9e211ff47a694a9a64f64820a7f284964e3def6709154c9b"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "f01d7e5a714b3eda091eeb4c8a58c63c5c71145d24ec7af7c9b8f593937b8463"
    sha256                               arm64_ventura:  "21330f256de6a23a1e3599ebbf66f7ca6f9c4a0793d29e3b863bd4c213e4fec1"
    sha256                               arm64_monterey: "fd6e2fad46881592a9ec06ae4183b02727cc9883403136381c6941df275fea03"
    sha256                               sonoma:         "65a979f2b6709c6dc45d45857fdee3a991b015cdb95a30f946fa098f4e89b8bf"
    sha256                               ventura:        "8cf7822a7352c47931883fe92d1eba4ec136933e2503186c733ba0abcc9e3736"
    sha256                               monterey:       "a6a51b1065ac219f48013d5f909928dab277a3ff6e99035721cfab086d5c0bd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "010ab7a4ae39b25172b852ebab6c1575a59fdc73643d9dd6c3743658c08a7059"
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