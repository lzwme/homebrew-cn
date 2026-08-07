class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.30.7.tgz"
  sha256 "d047bb045a26dc9b78e66e0b44b1f4f5f91dc67ef5625b0617dd5329121f800c"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "975c67be0d46ef16987892f452b0ba52036ab949c17d02be357c34b00e6b6aae"
    sha256               arm64_sequoia: "2e77a4e4c690140514012ca6deb5f2941007c00b25a32bf073b5f803d4264774"
    sha256               arm64_sonoma:  "220dab057da103eaa4b7cb28af2e13280ec9f83fb00a2dc15c829dca1523b3a3"
    sha256               sonoma:        "874a98c5eb6229c4ad1097e0835221294d12c3246c6dea6f70c0694a533fb892"
    sha256 cellar: :any, arm64_linux:   "f69ba5831d6e71049ac562586e17760f70ab1a379b82047696aba159159d4e9f"
    sha256 cellar: :any, x86_64_linux:  "4c8e41cebc43e8a771fce6fc9e7e938f765a48df1ee6733be9218aa0cf8ac30a"
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