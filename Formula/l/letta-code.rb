class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.30.23.tgz"
  sha256 "5abbf774200b4e2605f27b9d938840e41d52a310d1d9dd8664e19292cac65c88"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "dcc27d61e1c227763020c762dd10cd80fc64ccb2521e584b98aef7c238842516"
    sha256               arm64_sequoia: "a94f9c730554f483300541bbb486d086259ff191c0dda589d66f7e303b45af1c"
    sha256               arm64_sonoma:  "46f5f40de39f59ba1cba8e8405f9bd09262095bbcac4ec581a5a4492ce846a8e"
    sha256               sonoma:        "0cae793079b7a7a9c0208f654f404c7b3f2456eb0acb14962de500081f840c46"
    sha256 cellar: :any, arm64_linux:   "403c5ed4262bc1bb5f3d8f7654a7765e75c0d5bfa2042286a456b822bfb91883"
    sha256 cellar: :any, x86_64_linux:  "27ac860f239ea5f29b3062b502f85f680ad0ca5dd794efa2fc00f89a4a0b3284"
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