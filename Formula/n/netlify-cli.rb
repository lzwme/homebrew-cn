class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-25.0.0.tgz"
  sha256 "849e1acf595c09933f07be70283af7de82b0b41ebc9a37f491d85a855cb82b93"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "faee6df88a3888ecc869168de507aa593f3226095cfa98f464a64ff729458dbd"
    sha256                               arm64_sequoia: "541d9ea81e184bf69c8a9fc282b629e777c355b579113982c0db916fe1f327f2"
    sha256                               arm64_sonoma:  "13c5e7c6343d52e11705a44e814f24d00c6fc46e648c75f78e1280cbbabca286"
    sha256                               sonoma:        "90f6575be7668abe0bfa300b43e65caf8a985d0f4cc72a73602b6dca2d653442"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d9c4ccc5532004c9280b855090cd1557d4e46ec8581b0b798fa60c9f877d473"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "826cfde7040a8d36a48aa3d08df8eefa9b93141d73cfa275dde1f52176ae17d3"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "node"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "gmp"
    depends_on "xsel"
  end

  # Resource needed to build sharp from source to avoid bundled vips
  # https://sharp.pixelplumbing.com/install/#building-from-source
  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-12.2.0.tgz"
    sha256 "8689bbeb45a3219dfeb5b05a08d000d3b2492e12db02d46c81af0bee5c085fec"
  end

  def install
    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"
    system "npm", "install", *std_npm_args(ignore_scripts: false), *resources.map(&:cached_download)
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible and unneeded pre-built binaries
    node_modules = libexec/"lib/node_modules/netlify-cli/node_modules"
    rm_r(node_modules.glob("@img/sharp-*"))
    rm_r(node_modules.glob("@parcel/watcher-{darwin,linux}*"))

    clipboardy_fallbacks_dir = node_modules/"clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir, force: true) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match "Not logged in. Please log in to see project status.", shell_output("#{bin}/netlify status")

    require "utils/linkage"
    sharp = libexec.glob("lib/node_modules/netlify-cli/node_modules/sharp/src/build/Release/sharp-*.node").first
    libvips = Formula["vips"].opt_lib/shared_library("libvips")
    assert sharp && Utils.binary_linked_to_library?(sharp, libvips),
           "No linkage with #{libvips.basename}! Sharp is likely using a prebuilt version."
  end
end