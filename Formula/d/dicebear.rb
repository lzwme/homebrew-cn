class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https://github.com/dicebear/dicebear"
  url "https://registry.npmjs.org/dicebear/-/dicebear-9.4.1.tgz"
  sha256 "175763ff506d7979b927ae4b3941cf4beb8f1568a1bfd295c85893ce876438c5"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "8c7a8437bb4de8381981886ab5432fc232aa4f744c7861aca6c369d34dab2046"
    sha256                               arm64_sequoia: "9eb3788cf7882d2e7a912c45cdc9b6ae02ba3eb038e3a9e56ab9da24da80cf7c"
    sha256                               arm64_sonoma:  "cbe7e37a05c3566744b2e31666b56a48a155df9abac188343ba5aec1236b3d73"
    sha256                               sonoma:        "8d7d02b958016c49c688eb2abdd3fdaa5d3e47bfc3421409264a7bc1d6162cb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b419f621cfd452a0accd6abb2df8d48dde9d50d7c9591e7d2c1593772ee44209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d01385a058155fd86a568fd93bfbd3ccc1cc47a0b2d4a05784584782ef837288"
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
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.6.0.tgz"
    sha256 "e3029e9581015874cc794771ec9b970be83b12c456ded15cfba9371bddc42569"
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