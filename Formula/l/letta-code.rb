class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.27.23.tgz"
  sha256 "ca7ac47e00660eb549fa5d9553c881e09affcea14ce4e3716038b385f2e8d5ab"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "6714cac615625b3f71f7cc881cbdb397c439f027167e72273dcf20bbf48302ef"
    sha256               arm64_sequoia: "a196cf9df22b09438c8c87da5676bc0571f7ed65e0b013ae6002d0b51b3249bb"
    sha256               arm64_sonoma:  "afee5755d2a947d7652d669ab48f326d5ff8ce82ad9d8130822a7ef569c8649f"
    sha256               sonoma:        "23e3dce70aa863674346894dc9a34d2c298ef30b5ee5edc8b257a0ed3e6c06ec"
    sha256 cellar: :any, arm64_linux:   "d83114d9a83103d5f067baacd62b74597b12703d0aa1582181224a71a5316167"
    sha256 cellar: :any, x86_64_linux:  "08d27d6fa4c4a397f6c021e61f44fe46608af5888e94135aa1334830843e4a0b"
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