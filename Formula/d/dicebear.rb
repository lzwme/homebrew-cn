class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https://www.dicebear.com"
  url "https://registry.npmjs.org/dicebear/-/dicebear-10.4.0.tgz"
  sha256 "e26cfb08cf4aa183d3701f3a04400a2deef68a9f483d088273beb498f97e0574"
  license "MIT"

  bottle do
    sha256               arm64_tahoe:   "c90c0b0557b9a7fbe5f5a9fddf6058e2063a0f49afd16acf8d8c276e8790b146"
    sha256               arm64_sequoia: "233cb52b673c10b8ce0a9ed3d1a1a2de6cf084aa5a84949e9a84a936e1d49a7a"
    sha256               arm64_sonoma:  "3b520f6eaf63275871af023dae98a89f2b82d2596b3be2a75b29e177d87d2f10"
    sha256               sonoma:        "dc8bee50e9851a41d4da0590565c6b21d24e6e41173d9a175b61a05e4a3b6e7a"
    sha256 cellar: :any, arm64_linux:   "3e93bbb6d4f757fcb1a99c4d1be14ace30003fb3e3c9a838a72f14493fd0477a"
    sha256 cellar: :any, x86_64_linux:  "ca00593fa581df1f46ae6e25856951375647358a539a8ce2191f35ddbba15aa3"
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