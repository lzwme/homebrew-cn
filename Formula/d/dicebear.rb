class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https://www.dicebear.com"
  url "https://registry.npmjs.org/dicebear/-/dicebear-10.3.2.tgz"
  sha256 "00530170b5031ef73fb3a43658d7121adb7c7616bdfa2666dc2b9fda73f27cdd"
  license "MIT"

  bottle do
    sha256               arm64_tahoe:   "0f3d86452f8afbec1139133caf0c862ab1bfe12e94228dbe63609b4d749ee0ab"
    sha256               arm64_sequoia: "298a0664ff53defe4d303ea56a7ab22e7f45a4a0041c0b09bd8106067a4b701a"
    sha256               arm64_sonoma:  "7ff752f500ea00262f6714487632b34b6a3620b6c3e1ca98ed8dcec17b08e55f"
    sha256               sonoma:        "cebfd6d32ca39ee1c2deace5cee9e694e8b231e44371ec8faad23485872f5c1d"
    sha256 cellar: :any, arm64_linux:   "1c7cfe6036bb1dd3003784efb39cbb84a7e7f2e73e6f6090a69ca8aa2f296f4e"
    sha256 cellar: :any, x86_64_linux:  "eb4c443183c9915004e9eb4ee9f3b11a8c2823c668617be765de30567d3b8875"
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