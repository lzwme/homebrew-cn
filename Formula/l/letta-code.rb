class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.30.32.tgz"
  sha256 "37dfc4d0dfb471ffdf43e7e40114854dbf126fcfa4b838584cff967984ce617a"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "4e576d3eb73bf4e7e3704e8398516c4c0552f500b36bd950cf34901197501c17"
    sha256               arm64_sequoia: "e833506cf66d46455b95527f77be40278f39705a4ada0ae8a3b8b24ec1660c69"
    sha256               arm64_sonoma:  "00fdfd7583c6dc5be210ea5d9179980a3a9b90979f09ddbc9c0062e96a6504d4"
    sha256               sonoma:        "dacd2e019a12f06c9dd8418bcb7f8482f1531a967772a06e4c15736ced787b38"
    sha256 cellar: :any, arm64_linux:   "3738cc8acf4bb5480077b72b51d6c71ca588d03d2f8a4108a18cb10120871def"
    sha256 cellar: :any, x86_64_linux:  "b7e9b2fc71700ef05707c070f0140e20e9a9ae0969711d543a81f46167bbb113"
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

    # Remove Electron-only sharp fork with x86_64-only pre-built binaries
    rm_r(node_modules/"@janhapke")

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