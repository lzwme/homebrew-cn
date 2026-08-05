class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.30.4.tgz"
  sha256 "681c6b75322f9280e4262b677eee713c01cedac4a6ee2c566fc3b017b5a7c897"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "14c918f6bd5b12f4290be25caa0a8d9c8c2e437bf3bcc6dd4c6ee1992293a9ae"
    sha256               arm64_sequoia: "0528a11cd946a31533d14d29e95665e476086e63b5967ed6d53d8da556e88cdc"
    sha256               arm64_sonoma:  "1dbabc34df35fc41eaa60af8849bac40f7305b8f333ab6af12a1bcae5e8bea1f"
    sha256               sonoma:        "236e0fcc0b7feb6e5dae2971e482cac7441424b45669f881a25604e20044d2cb"
    sha256 cellar: :any, arm64_linux:   "01504d2db267673b51fedc27a835b3440ef3201e47482010bcaa9eca7d3585ce"
    sha256 cellar: :any, x86_64_linux:  "c6d221f89f98aaf2ea604e46fdb12538bd72edd5e94c57e734a8e3b2c1b12c69"
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