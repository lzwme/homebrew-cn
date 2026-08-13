class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https://www.dicebear.com"
  url "https://registry.npmjs.org/dicebear/-/dicebear-10.5.0.tgz"
  sha256 "97c62ca01fc2cb9e82bd4c2982c29b5cb6407323de29a742e54b30c53da81d96"
  license "MIT"

  bottle do
    sha256               arm64_tahoe:   "e7905dc33269afff9a0df5a49af1015053bd9399d2a9090cc87e84a7df101624"
    sha256               arm64_sequoia: "8fc724a7d03d6528b38474d9d94d39b8da996e2004bae147dc8cee7e867a55c8"
    sha256               arm64_sonoma:  "dfe44245f53f015029430cd82a5e0c5906b85f4e5e059ee2f402d44f49142ddb"
    sha256               sonoma:        "71ae16204a7a34433ee6f58d291294b1922055c7697c0d0c961b4d8abba3c5d1"
    sha256 cellar: :any, arm64_linux:   "183baca81349dc590583630649b13cd6b019bf7d11032d4b19ce07884702fb27"
    sha256 cellar: :any, x86_64_linux:  "258e5f74c932d1c7dc3ae3ca9531b6a31168ce2eb52d543772d6f9ba4b5f18b4"
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
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.9.1.tgz"
    sha256 "9091c2a5e57dae6ae5a0ca9c42d6127586bed4168cc1a342c95b64e61efd60af"
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