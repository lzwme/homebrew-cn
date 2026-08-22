class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.30.28.tgz"
  sha256 "fb06fec69e531c28f9d82e2271162e01181361531cc7da7bca642f29df0af867"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "103119791e8ed3882bb2cd42ebabdd3793d2a0442b133e720036becf1345bd51"
    sha256               arm64_sequoia: "69b5172be6cc1cb4e3bc42df071bba11fa304c8268b698af613b4a4f2021bd56"
    sha256               arm64_sonoma:  "e9d532aadce26889aca66d8be9834db59e99b973a3c33404fcbc1022cfce6aa7"
    sha256               sonoma:        "20c8a15d56af886e69c875074a44617f30890000a6a86cdd1a6543c6dac30bef"
    sha256 cellar: :any, arm64_linux:   "927015664f9c46720a9cf2582e0837ca3242ad66bd3ddd7b8d0b9d1568a157de"
    sha256 cellar: :any, x86_64_linux:  "8445a2193c2751b50f7b920ff6d52352610d94d7ecc5dfb610644464adba97d6"
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