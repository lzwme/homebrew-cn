class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.29.5.tgz"
  sha256 "62d60565b87ffd523433f703e07ea002a756aa2d166317cd7a5e5f6310593ac2"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "760a3f380519ea948f6a78e2f307918eafb5bc507bfe3b32725d94198cb9ee30"
    sha256               arm64_sequoia: "e5435941ee880ca9d1f29e459dc1b86d0eb6bd386b86784ce3feede7adb54475"
    sha256               arm64_sonoma:  "1ca3e5db0b8c1ef3cccbc114fb5d498a21cb61b5828750b6f88b62c5b084ccae"
    sha256               sonoma:        "d8d6299f6f00ad25c5534ae803277dbb67c69afddc60196d9dfa843ba159c6b2"
    sha256 cellar: :any, arm64_linux:   "0848430ba3e20f9be9a185a3f6f5a1ae1491264d1a1c3acf4f813465aee1ec38"
    sha256 cellar: :any, x86_64_linux:  "c2a80d3f09394ac7545c141e1f70da8339cf995241bf40f4322aadeba0c01406"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "node"
  depends_on "ripgrep"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-13.0.1.tgz"
    sha256 "455327cde805c299d5a16603419e106853db5b9257dfb85e44eb7f4ec4d99de5"

    livecheck do
      url :url
    end
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove ripgrep pre-built binaries
    node_modules = libexec/"lib/node_modules/@letta-ai/letta-code/node_modules"
    rm_r(node_modules.glob("@vscode/ripgrep-*"))
    rm_r(node_modules/"@vscode/ripgrep") # keeping separate from previous rm_r to fail if missing

    # Replace node-pty pre-built binaries
    cd node_modules/"node-pty" do
      rm_r(["prebuilds", "third_party"])
      system "npm", "run", "install"
    end

    # Replace sharp pre-built binaries
    rm_r(node_modules.glob("@img/sharp-*"))
    resource("node-gyp").stage do
      system "npm", "install", *std_npm_args(prefix: buildpath/"node-gyp")
      ENV.append_path "NODE_PATH", buildpath/"node-gyp/lib/node_modules"
    end
    cd node_modules/"sharp" do
      ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"
      system "npm", "run", "build"
      rm_r("src/build/Release/obj.target")

      # help letta.js find source-built sharp
      sharp = Pathname.pwd.glob("src/build/Release/sharp-*.node").first
      (node_modules/"@img"/sharp.basename(".node")).install_symlink sharp => "sharp.node"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/letta --version")

    output = shell_output("#{bin}/letta --info")
    assert_match "Pinned agents: (none)", output
  end
end