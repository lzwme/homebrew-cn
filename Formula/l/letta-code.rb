class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.28.9.tgz"
  sha256 "70b37cbf9e6199299a46299913ea5da724dfa7e25222ecaeb0487aea5e7378b5"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "cfcb47a554ad59572ba5e8d1e22bf07545191200a0184657c653ebf7f24e9bcd"
    sha256               arm64_sequoia: "357704def47260fb44fd9fee151293c6b272fb1e73f7a0d3c7eff998237af475"
    sha256               arm64_sonoma:  "aea9b377c06ff303875c97d4b392fed0940af1898d5488ac5867b8aebbba4b96"
    sha256               sonoma:        "e0952a3766cb066fefb3bca8fd9b75a14e396f2aa3ea84c0876ef443579fb77e"
    sha256 cellar: :any, arm64_linux:   "c90581d79372f79221fac6bc9bf5ecfbd9111299c466bfd339af68835317c575"
    sha256 cellar: :any, x86_64_linux:  "06e20c72d483cfc2ed74849918dbb1cf236704fc5706c233d213475977258a58"
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