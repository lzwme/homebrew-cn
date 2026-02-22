class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https://github.com/dicebear/dicebear"
  url "https://registry.npmjs.org/dicebear/-/dicebear-9.3.2.tgz"
  sha256 "d700e8a6fcced026b4118bcf77f4bab41c843d804fbbdec0b1cce24ad8030d4d"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "5dbb477d32ada5b7786bd208c5851d82276f1c1321ac67fa07cac29221801553"
    sha256                               arm64_sequoia: "1220b1055c921941bdd2e6030c2a849a055bd32cf05aa999ded4d86eebc5c77c"
    sha256                               arm64_sonoma:  "b9a3c8495601160710cb07195b7934d2b092c64f1c0e967ffa743cbdffa807c2"
    sha256                               sonoma:        "3988e84e91ebd760447afe77612ed1a6e4206574397fd418d8a2eb8a697bbed7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64d047a513acb032107cd43d871fb3746e82806025eff993e716466ab97b3a7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a38d94d8ddf385f2cc990ac1783ee5194f991513effa0ca55b131402351e48b4"
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