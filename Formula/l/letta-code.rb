class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.30.25.tgz"
  sha256 "d644cba8203d35acf65af5a1d5b163038e0282004bfe57329e6520036b883052"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "87d1ca77cf3bb9b962e84b9afc1466aca5cce737d1f6c715cbdfebe87c300b42"
    sha256               arm64_sequoia: "30ae5ebd09412bc16b2b2f320a62a7b25fc62e2f45c7257e1a0cda9703a0efcd"
    sha256               arm64_sonoma:  "623c63c6282c7896b33e9c34c9f4b18d68384e5bb4730e39f70d8c9ddfeb8245"
    sha256               sonoma:        "866565d24eb6ab60c2de53a452e1ecae89583b800ed99d041c45bd83bd6b2404"
    sha256 cellar: :any, arm64_linux:   "4964298e5443f6660f3d89e6a622ea76b82bb507fcf27693ed8fe98195a9d970"
    sha256 cellar: :any, x86_64_linux:  "ee564b20d6fdaf32b3d8d987275cc4d6f18f929fa6e964321f82004729a49996"
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