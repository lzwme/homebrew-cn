class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https://github.com/dicebear/dicebear"
  url "https://registry.npmjs.org/dicebear/-/dicebear-10.0.2.tgz"
  sha256 "b16679d993c8c2fae5f0d86474900af49909266041deb61821b62444e95a6e18"
  license "MIT"

  bottle do
    sha256               arm64_tahoe:   "f64dc56e8fd989122426022dddd5e993cca13bd8e2f112183f675d2eecc6bec4"
    sha256               arm64_sequoia: "9f2112f36096218f7047b5def958fb2b2d88676f8d0901f3b3817f964cb9b712"
    sha256               arm64_sonoma:  "e47471548e9ecb6f75d2a3c323fb626c5d5dec99557e2c7d7b4a7d73cf174478"
    sha256               sonoma:        "5b9b24b77f8e3d412e4d7bc237b9583da23203dd71647793cb0a68dc46d2d4b2"
    sha256 cellar: :any, arm64_linux:   "bd6fc2d5820d5b34126fe01f6a473f11bd7c3ce78a6c8da8d5e5185bce42aedc"
    sha256 cellar: :any, x86_64_linux:  "c72e8f682003402c67d235a62b013e4bb8fec5ee54739e5ca6ce0f582a936853"
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