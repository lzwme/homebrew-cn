class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.30.21.tgz"
  sha256 "e0901600860e87479de4a89450d11297e723f69e4143ab7e40f25cad4f312501"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "d66edcf16dc77ebb305e3ef46fdd467433e0014e22be0a840dcf0294ecc42353"
    sha256               arm64_sequoia: "ae4755351a0087b7674ee97d64afdaed1cb4710713e2ba4d271dd1c9ea44b1f1"
    sha256               arm64_sonoma:  "d362934ceee3ade02bf04c7de27379b675cfe8ace2e367af997e08952b1894bf"
    sha256               sonoma:        "bb2379acbc576f7f1b3b295374ca7d75798fe0965c8549d2f3ad6ffe54497878"
    sha256 cellar: :any, arm64_linux:   "e178ae37b1cee6cd02d9149ee04e5853d6cad7be0be0a70f6cfb25cff9c0d19d"
    sha256 cellar: :any, x86_64_linux:  "d0bee5915e2704fc689f43d4096c61f59e2cba585ae29127e1ce96837d42a521"
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