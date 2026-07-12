class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.28.1.tgz"
  sha256 "87812bab8cd8fef17ef131102fa926aa6528af6985171fd71c994e64a62523fd"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "958eb5157c79f5c152c6f82f9b05ac0d0d0d9e7f327f95485acbbc9cfb5d639c"
    sha256               arm64_sequoia: "d30464677315448654b9c9ef19ce47238f58036848c57325c29d52b381118902"
    sha256               arm64_sonoma:  "bc444ab061184485d25c1170a2ca305adc27df2a31a96de97b8a4679f6519b2a"
    sha256               sonoma:        "dfa2ad7b879836fb10e5a27d66356e8bf8f2844e5c559d357c9b61862fb20c7b"
    sha256 cellar: :any, arm64_linux:   "209dd3884108ddce4311ad837df220b8429a1c6393f1da55bb5e0a5535f4f727"
    sha256 cellar: :any, x86_64_linux:  "73d3a845f19d9d5092124d972b705f69009646c0fbdf5a48707a24b1b1f9383e"
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