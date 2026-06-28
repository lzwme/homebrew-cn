class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.27.18.tgz"
  sha256 "3d910465ba2a9e43a6af4d4222609f60f1bc1beb3cc37a0ace07b7744161b1bc"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "d24832959c8a90f0926ba39aced1e9d28dbdd45e21de5a34892ca92387dcee04"
    sha256               arm64_sequoia: "d6f952aec5fea6641596038c470e752478e68310210b0773f12dc5802eb2db28"
    sha256               arm64_sonoma:  "25f6029e864e523195e4e4c436d39b5811fbc6efd6839e7caa274def53da3c66"
    sha256               sonoma:        "513343ca6e1326d888643c436df5a51e100f357ad7a2c95a85c50b200af3d14d"
    sha256 cellar: :any, arm64_linux:   "ec91c5d6ebe8052387749d15e9461fc5166b473b59488bb4844a97e34e3c1231"
    sha256 cellar: :any, x86_64_linux:  "49f925db466fe5872dc173a433445e333372bf2bc61bad25b57447bac0a4e1c0"
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