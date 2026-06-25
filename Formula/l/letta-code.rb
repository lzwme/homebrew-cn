class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.27.15.tgz"
  sha256 "901054f8a0be10adaa5ca707f88587e2132251b01e19ee60e7cef85ba5e5bcc6"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "3d770a772004632fbd2c013bb03ca40b06dfa488f69569d7ef99c9461cd8d923"
    sha256               arm64_sequoia: "5f52dde3ae2bbc76e4b9c16f86392a285a3f0d95e01db4359dde6363693921f1"
    sha256               arm64_sonoma:  "a61c0633431bea2a89830f04ae395d4d889526ba33f280f9b189b39ead4a157f"
    sha256               sonoma:        "a83b0933d5b9a51eb4434df9552d2cee5c239338dd02e2b36f49d5b2f7d105d0"
    sha256 cellar: :any, arm64_linux:   "3c759030de5fd54ee0c161cf6fddb3628a3c42bf87ea8abb3271391b1a34d76b"
    sha256 cellar: :any, x86_64_linux:  "b05f58c34ba30cd3d1002c4dde2014fbef050f4444b01c5b587ad29af1e00cae"
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
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-13.0.0.tgz"
    sha256 "10e45f33997680c9ea6ebfb8c575aba66bfbe8ad9c782a7426a37440b28b62a6"

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