class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https://github.com/dicebear/dicebear"
  url "https://registry.npmjs.org/dicebear/-/dicebear-9.4.0.tgz"
  sha256 "f81355aa528371341dbf7007ae84f42dd0b0fcca50896762a19b6b6763f46af2"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "55aca3510b08bb12217b0c7bb4937271c377811b52627818ddd2cb0b3508ecd2"
    sha256                               arm64_sequoia: "89e7408bf53a7c86d2b6034c44edc344bc5925e721de6244891c8955cb9fe4f6"
    sha256                               arm64_sonoma:  "3ef4baa4b9f36759430529c67805365e4709e82112f1d964f28f5ebf40de71fe"
    sha256                               sonoma:        "7b27b7280579f6919e3a6496bf10ebdb6011e7bf9090934101d22845848ae70a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ae0ef7bbad82a96d4537de2e2fa3bf042586025b224633cb75b336c79686e86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6081b3bd16dfe70f338afb92cf77cb88023a6abf0e54707c547dcf380c3e345"
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
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.5.0.tgz"
    sha256 "d12f07c8162283b6213551855f1da8dac162331374629830b5e640f130f07910"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-12.2.0.tgz"
    sha256 "8689bbeb45a3219dfeb5b05a08d000d3b2492e12db02d46c81af0bee5c085fec"
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