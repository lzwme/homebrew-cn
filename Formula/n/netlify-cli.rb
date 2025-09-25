class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-23.7.3.tgz"
  sha256 "e0da1a03f1f59ce2ad2138b0cc4b99de0ff25d24ee6c0bf709253416b0852b2d"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "d0d236e77c797784825ee3215a4f3c32a33508b97af51a43e84742f0bfc13c6b"
    sha256                               arm64_sequoia: "f641093d51c3b1fa8e0d0ca8ec318bd26e0e71ae28fc87716304ca5249cb932a"
    sha256                               arm64_sonoma:  "aa545077ae72343d3740583a5ed1867a089ea455750d6e85f5f5e632f286259f"
    sha256                               sonoma:        "fe90fc2885673e26218aafd1dafbe74b65ba178969f866c78c0018bafbd3bf83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94657586ff2b6b1cdcc7b0bcd1819f9e005eef622d01107ad3d913174b10b56f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69c6043db77858eccb2660084564be74d4873c9136c51a4749a3c95968d785d0"
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