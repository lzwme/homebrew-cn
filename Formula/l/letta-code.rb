class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.31.4.tgz"
  sha256 "6713483b02d1c76c5302c642e4aad6b698979aa55178279c9ba0b3dada6404dd"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "22b3aa0051c6617f57c081fd0963146ff361c1fe437e229499b8c369c605f047"
    sha256               arm64_sequoia: "bdcb2520d29b7d4905d0af00ac5961af170c516bd6c875a8048bf181058e719b"
    sha256               arm64_sonoma:  "014a9033edad0f924eaeb6f4941ea5a252cb87a50fce81446df8017395f7fcf0"
    sha256 cellar: :any, arm64_linux:   "397ad3538872d6965dcd3be163ced7a4566b3295385144fde91a6d9f1a9aafd0"
    sha256 cellar: :any, x86_64_linux:  "d2927392cd9033ebbb9d72ed176caf7590ce2e0227d1a74685eab6cf4eda0be1"
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
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-13.0.2.tgz"
    sha256 "1b1524d914331bd01312729e31a828192d53af84e113dacb6e36afabb6c21a6d"

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