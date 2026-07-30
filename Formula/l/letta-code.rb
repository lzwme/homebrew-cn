class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.29.9.tgz"
  sha256 "62e6d4baeff3d634b36754ebbadc7a075473e6295bdfbaae659aee91cb148961"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "fd879760934203107ae99bf5cc6f8fdea5515e22bebe1b8a55408f576b0e5fca"
    sha256               arm64_sequoia: "b6dc9e891a2950039be2db20e5074f2010e52553f55684a5c88b5f391bb4c0c5"
    sha256               arm64_sonoma:  "2c4b7ab0a3a3969401b028e142c51e72ccd4fefbc6c6c64b0488ffcf88fa2deb"
    sha256               sonoma:        "1fed0e4c1eb87b8ebafe6abde6bde59dee83945fddabbfefacb317b4e1a6135c"
    sha256 cellar: :any, arm64_linux:   "0ff325ecd80e26e285250c707f773e1978eb42f3abe15379cada5a81c704fe74"
    sha256 cellar: :any, x86_64_linux:  "44f9fc1b6b24db9c49ba65bc8520d3a677e83935a70fe98f03309e25fbc92626"
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