class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https://www.dicebear.com"
  url "https://registry.npmjs.org/dicebear/-/dicebear-10.3.1.tgz"
  sha256 "4184a899899ad27da2a77080d0c87003e24acbb99f5a1ca220e75127bee640ce"
  license "MIT"

  bottle do
    sha256               arm64_tahoe:   "627b1a6c5777d4c331933f5756bce8425ae1548902ab968a1a9b731f8a2b2189"
    sha256               arm64_sequoia: "5473b677363486d91cc6c8fec4629f520066a80934dbd59d5dfa31060f248680"
    sha256               arm64_sonoma:  "147160bea13d297d4765f3bce27dad7461781d7dccc865e758adf869bc28be2a"
    sha256               sonoma:        "d7c6a643060401250d14880270ab5bb2c08c0f33f05b7d58cf9fa8fdc857ef5c"
    sha256 cellar: :any, arm64_linux:   "194d9ffcf032a10d689ccb9b24a044f30dd5c6a3775e4870f8ee28cbfaa100a0"
    sha256 cellar: :any, x86_64_linux:  "220cb07b4b6d65e058e4c340b84e68418e50b76a8d3abd84aa72f9a7f7ac22ee"
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
    rm_r(node_modules.glob("@img/shar-*"))
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