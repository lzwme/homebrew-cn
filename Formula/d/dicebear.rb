class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https://github.com/dicebear/dicebear"
  url "https://registry.npmjs.org/dicebear/-/dicebear-10.2.0.tgz"
  sha256 "c82c4fd39ddde5916a907adfc8001a25728dbf066e834b2d62f8bc70849071a1"
  license "MIT"

  bottle do
    sha256               arm64_tahoe:   "9baa67dc65e08f2dc6da949dcb1b0e35d1ac47b1318680998a4283e951bd2701"
    sha256               arm64_sequoia: "34d2f9d5ebf50f97fa9789b56b5873ce6e47c4c73a5fb16f9bdf35c61951dfc3"
    sha256               arm64_sonoma:  "6fd0a61b43ed6aa3831db1185e0e9eff6a6e87cf2efdff7972a1a30558575d23"
    sha256               sonoma:        "b402b2a4606f83f6816ffbdfe811671912513d907466dc6a13395707e7ed3405"
    sha256 cellar: :any, arm64_linux:   "5eb3d2ec49dac1835202c56082f69d68df74f5ecdeb8822598ea37acc674302a"
    sha256 cellar: :any, x86_64_linux:  "2b13a30f58245d43231494c80e52767a0bb18fcb936ddc92b2ba0a4e1ecc10a8"
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