class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.30.8.tgz"
  sha256 "f5c7ba3af5fe5871142b7d88978745cecd4121dab9bf7195a009f0232f420db9"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "c950e67c9c3c11eb50c606de27e60e3b3460e471b9a1d91cdd934092fb6085f5"
    sha256               arm64_sequoia: "ebd7514b7544c88618be399c24a484336b886316261e3779992beeb8a2e8692e"
    sha256               arm64_sonoma:  "88c62aefa94b1e46343c4f0a4ae5bcd669505e108542e2985185eab3ccc24ce6"
    sha256               sonoma:        "891517013aa26c3d860e0f26ec310c4d9142acd89cef55d74e64efd1fb01ac0d"
    sha256 cellar: :any, arm64_linux:   "42eb39222ad50ace682c8068b2774ec64ecf0768473993016cc5d7673ac46077"
    sha256 cellar: :any, x86_64_linux:  "ae9ce3be08703de10278d221614ce345fac07a904190615a2bdb3d65e115e54b"
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