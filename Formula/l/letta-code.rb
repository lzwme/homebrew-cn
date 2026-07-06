class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.27.24.tgz"
  sha256 "69cd5241d7d99d81d944ab6c491754470a6b72d7023dac709c1784dd11fb6f2b"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "aea2d6b834d56fe28ae952122d9a05d13be5bacee8679d82a5d8c9b3f8d73060"
    sha256               arm64_sequoia: "2b1f0b7fc3b92f8702b795f79717a3aecc9e5661b7cd8e2555b6a0a5aba78ae6"
    sha256               arm64_sonoma:  "21205fab2d465737356e07d2e2fafaa3c633ae97868339de6d6204fe6e3edcf6"
    sha256               sonoma:        "c1967761de8cded1ff0bbbc7b626c49fc5e77a6a7cc97515c8780376dd448fea"
    sha256 cellar: :any, arm64_linux:   "760336f500a5f10ab76e8e663c5cb5589f09af7341f576f53e78c1b7beadabdf"
    sha256 cellar: :any, x86_64_linux:  "8ccf11bf7188f9880fb153640b0e5d5fb5e511c6dbed530e0cdc9f2c43635cae"
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