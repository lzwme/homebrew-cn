class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-22.2.1.tgz"
  sha256 "2ef320908045bd9e0911768bbd83030a86c8c7deb96426220f0e5e4c61f54bab"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "bd3e1a86d922c197555e3edc4e71c01bbff43dce6a88aeff7492056aa4821bf9"
    sha256                               arm64_sonoma:  "c946126d93394eee3260e4b5397bdf0547677f0c3ed8f2b683bdfdaf20aa567b"
    sha256                               arm64_ventura: "9233a81ba62847bad0026f7d5fdae2e4f47cedf5cd289739f1efd2dc1664c94d"
    sha256                               sonoma:        "ca0ef728789f7807b7f9e5341e1aab778b976c1622643909a2989fdf727d9a7c"
    sha256                               ventura:       "0870cd46991fde238c249e078b754d56fe711274e16500705413fecf8d3a5a96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "580e548899fe4dbd3d2c45ef7988aafbf0637dfbfc2de82fb3cb7926bdf79e6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd4993a14c4c547cab24854839da7b58a87f10d948200a8da0dfdcb18ee2c66d"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "node"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "gmp"
    depends_on "vips"
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/netlify-cli/node_modules"

    if OS.linux?
      (node_modules/"@lmdb/lmdb-linux-x64").glob("*.musl.node").map(&:unlink)
      (node_modules/"@msgpackr-extract/msgpackr-extract-linux-x64").glob("*.musl.node").map(&:unlink)
    end

    clipboardy_fallbacks_dir = node_modules/"clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end

    # Remove incompatible pre-built `bare-fs`/`bare-os` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match "Not logged in. Please log in to see project status.", shell_output("#{bin}/netlify status")
  end
end