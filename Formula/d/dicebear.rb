class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https://www.dicebear.com"
  url "https://registry.npmjs.org/dicebear/-/dicebear-10.4.0.tgz"
  sha256 "e26cfb08cf4aa183d3701f3a04400a2deef68a9f483d088273beb498f97e0574"
  license "MIT"

  bottle do
    rebuild 1
    sha256               arm64_tahoe:   "fe69e9995df64d504188b23ec779a61f4db662b7e86e75de760ef6480d9a82ae"
    sha256               arm64_sequoia: "1796bfc36c23c2118ccffc29af67bb56422774c12e005235e5b3c1dd13af9c35"
    sha256               arm64_sonoma:  "a63ebe71c05fbda63c8043994e12bf15e466a244fdece04efbb981197024b299"
    sha256               sonoma:        "816fb5051645ef10eef6acfe83fa758b949a00818de436fd7205f05a5cb892b3"
    sha256 cellar: :any, arm64_linux:   "85d7a8253287117fe473ef61a9d5e7ba332aab83ee060e97fc69acb6879fce57"
    sha256 cellar: :any, x86_64_linux:  "d07f4d77b9764b40c5c9229d5a635a794422183e32b3653ef534548653de35c6"
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
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.9.0.tgz"
    sha256 "19b87e2ce3a77fec0121ac97d7db088aae28aacfff481adab50d5f61b70e68f4"
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