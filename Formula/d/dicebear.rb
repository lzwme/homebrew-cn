class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https://www.dicebear.com"
  url "https://registry.npmjs.org/dicebear/-/dicebear-10.6.0.tgz"
  sha256 "ec9e72f59ea33765cba6916cd8ffe6412ffef8791f1825310fedf7c7da6d5078"
  license "MIT"

  bottle do
    sha256               arm64_tahoe:   "6b1d13c78fe14a08300dff7b1affadec766622569f3e27dd623ea3d696a5a45c"
    sha256               arm64_sequoia: "3271ec0560422e851a2a87a268cceecc64b33df0fd16febda6132d4ae34d05be"
    sha256               arm64_sonoma:  "103e1ccef30fd0ef154b86b3e844ab3a73165a97a2aaee0d1e1cff2060ab2068"
    sha256               sonoma:        "f4065d4d031e4596e59d8ec036ef6a096c76ca454d7df525382284f0c9fc11d0"
    sha256 cellar: :any, arm64_linux:   "b8cb13d6d84207759f66c7ec108bfb96059a06f4ef157c4654834048b82eb481"
    sha256 cellar: :any, x86_64_linux:  "279108f258324fd70c7118d46778188769b26e2365efa5663aa2bc2d752d6500"
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
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.9.2.tgz"
    sha256 "4cd65698541b19a33f798f1dc25c02c6ed1c9d7749b8824b1a1ccecdd197c8ea"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-13.0.1.tgz"
    sha256 "455327cde805c299d5a16603419e106853db5b9257dfb85e44eb7f4ec4d99de5"
  end

  def install
    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"
    system "npm", "install", *std_npm_args(ignore_scripts: false), *resources.map(&:cached_download)
    bin.install_symlink libexec.glob("bin/*")

    # Remove prebuilts which still get installed as optional dependencies
    node_modules = libexec/"lib/node_modules/dicebear/node_modules"
    rm_r(node_modules.glob("@img/sharp-*"))
    cd(node_modules/"sharp") { system "npm", "run", "build" }
  end

  test do
    output = shell_output("#{bin}/dicebear avataaars")
    assert_match "Avataaars by Pablo Stanley", output
    assert_path_exists testpath/"avataaars-0.svg"

    assert_match version.to_s, shell_output("#{bin}/dicebear --version")

    require "utils/linkage"
    sharp = libexec.glob("lib/node_modules/dicebear/node_modules/sharp/src/build/Release/sharp-*.node").first
    libvips = formula_opt_lib("vips")/shared_library("libvips")
    assert sharp && Utils.binary_linked_to_library?(sharp, libvips),
           "No linkage with #{libvips.basename}! Sharp is likely using a prebuilt version."
  end
end