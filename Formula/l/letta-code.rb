class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.28.17.tgz"
  sha256 "10deb90f108b766d20c0743878219a23a09e7bd409d1621e80df4c6e6088f0a3"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "ffba54e167c97d0481aefea7158fdabfa1ea6eeeb897ad46de3d08ecee7c670f"
    sha256               arm64_sequoia: "5fa060819f31fccb5f3266b6f8ea8d11c199507645626245c7b71e796234cbfd"
    sha256               arm64_sonoma:  "7a30d680cc004f178652fd7ceb5d612c0598e108f15504f807c6054ec704d23f"
    sha256               sonoma:        "418371f43d7198aa70cb0eb4de9a3467a22deadb52b20cd8732e67b4b50063f7"
    sha256 cellar: :any, arm64_linux:   "dcee32d98a8da66040580a4da30a038add527e2e20b6491d2c381cadc5e7f7ff"
    sha256 cellar: :any, x86_64_linux:  "08790d20e9b836e9df9847d8347f63445960432448f366320c59fa72d4fd4be0"
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