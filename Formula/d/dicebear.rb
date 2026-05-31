class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https://github.com/dicebear/dicebear"
  url "https://registry.npmjs.org/dicebear/-/dicebear-10.0.1.tgz"
  sha256 "cb539b052323ee9bd7b147a63d9d3303b5bec9a00c0b7f0c4faff27291936e40"
  license "MIT"

  bottle do
    sha256               arm64_tahoe:   "da1657b39fb35a4ddabd3746ebde3c92032218c8f37965d881735b55695ee645"
    sha256               arm64_sequoia: "5fdc6b7cd1c8b9e261e60692a5a0e30b9136f2252c7b8f946b30df4da11c081e"
    sha256               arm64_sonoma:  "b653a567e78de74d291cc66a8ac388464b6965b1911a70bc5070edb9afe1dcbf"
    sha256               sonoma:        "6466db8e7b110b0cf7837026de7f77312612412a0b36b176626d99e68e650888"
    sha256 cellar: :any, arm64_linux:   "e8481bf3e00c806b0b2f6f43019ec00762f7000ae66241819687f003daacdcaa"
    sha256 cellar: :any, x86_64_linux:  "1ab1c20ab7a15cf76736efd5ec5c2b7f99a84a45b28d88000926ce9f43e322c1"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "node"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  # Resources needed to build sharp from source to avoid bundled vips
  # https://sharp.pixelplumbing.com/install/#building-from-source
  resource "node-addon-api" do
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.8.0.tgz"
    sha256 "72528f1a8235a8bc19855e21cc5ae28252c276338afa73887dc7e54515bc76c5"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-12.3.0.tgz"
    sha256 "d209963f2b21fd5f6fad1f6341897a98fc8fd53025da36b319b92ebd497f6379"
  end

  def install
    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"
    system "npm", "install", *std_npm_args(ignore_scripts: false), *resources.map(&:cached_download)
    bin.install_symlink libexec.glob("bin/*")

    # Remove prebuilts which still get installed as optional dependencies
    rm_r(libexec.glob("lib/node_modules/dicebear/node_modules/@img/sharp-*"))
  end

  test do
    output = shell_output("#{bin}/dicebear avataaars")
    assert_match "Avataaars by Pablo Stanley", output
    assert_path_exists testpath/"avataaars-0.svg"

    assert_match version.to_s, shell_output("#{bin}/dicebear --version")

    require "utils/linkage"
    sharp = libexec.glob("lib/node_modules/dicebear/node_modules/sharp/src/build/Release/sharp-*.node").first
    libvips = Formula["vips"].opt_lib/shared_library("libvips")
    assert sharp && Utils.binary_linked_to_library?(sharp, libvips),
           "No linkage with #{libvips.basename}! Sharp is likely using a prebuilt version."
  end
end