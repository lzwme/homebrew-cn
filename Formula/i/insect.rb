class Insect < Formula
  desc "High precision scientific calculator with support for physical units"
  homepage "https:github.comsharkdpinsect"
  url "https:registry.npmjs.orginsect-insect-5.9.0.tgz"
  sha256 "dcb8d696e9209157f596c7c102cdc436d520629d2aed71585767af77bde2cb70"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a246e04de19ce3736e0c839afc375de68b0358dd475676268b30f369caf4c85f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a246e04de19ce3736e0c839afc375de68b0358dd475676268b30f369caf4c85f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a246e04de19ce3736e0c839afc375de68b0358dd475676268b30f369caf4c85f"
    sha256 cellar: :any_skip_relocation, sonoma:         "8077869bde22d8f4f44fb25ba149c47c7b39d80b1f5b0ad0e364a477be7c829b"
    sha256 cellar: :any_skip_relocation, ventura:        "8077869bde22d8f4f44fb25ba149c47c7b39d80b1f5b0ad0e364a477be7c829b"
    sha256 cellar: :any_skip_relocation, monterey:       "8077869bde22d8f4f44fb25ba149c47c7b39d80b1f5b0ad0e364a477be7c829b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8988d5e206cae71f827f36d7085acc298f39c3d30c92abda00610f3e01151dac"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin*")

    clipboardy_fallbacks_dir = libexec"libnode_modules#{name}node_modulesclipboardyfallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin"xsel").relative_path_from(linux_dir), linux_dir
    end

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    assert_equal "120000 ms", shell_output("#{bin}insect '1 min + 60 s -> ms'").chomp
    assert_equal "299792458 ms", shell_output("#{bin}insect speedOfLight").chomp
  end
end