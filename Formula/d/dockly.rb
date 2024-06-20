require "language/node"

class Dockly < Formula
  desc "Immersive terminal interface for managing docker containers and services"
  homepage "https://lirantal.github.io/dockly/"
  url "https://registry.npmjs.org/dockly/-/dockly-3.24.3.tgz"
  sha256 "3c1890a0ae136a36e9c8fabb343db35e4239a172fb284a77d3485a6bab939479"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "19a1212ebc54f897be5b13dbd9d404293d4cbca9aee9f9084d24e71c35deb83d"
    sha256                               arm64_ventura:  "ca1a2006d49625c5d29bc7dec3a517fc809ebf3f8160519dc2805eccde606dc6"
    sha256                               arm64_monterey: "833f43dfd7eb0780c0b64f54aee43a574b9af012dcdbfd65b09641989bfeb48a"
    sha256                               sonoma:         "b8431fa56abb1f35506f5864e5c8b0fe5360f5345088ad27ae90c2c22fb71c3d"
    sha256                               ventura:        "9c480dbf9c4f6dce0998464b8555c0c22025e87677a21b44daddf4c12f84f42c"
    sha256                               monterey:       "37cee7a7e33c2735d085fe8a6125c59855928eeff1cca8289d71fc73c0a2df07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c8d8ed0cd780b10c2c0f191ef6f2741bfbddc57f7d91a767acab9d12afdf7cb"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/#{name}/node_modules/clipboardy/fallbacks"
    clipboardy_fallbacks_dir.rmtree # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    expected = if OS.mac?
      "Error: connect ENOENT"
    else
      "Error: connect EACCES"
    end
    assert_match expected, shell_output("#{bin}/dockly 2>&1", 255)
    assert_match version.to_s, shell_output("#{bin}/dockly --version")
  end
end