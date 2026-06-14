class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.27.9.tgz"
  sha256 "e4e81f1dbb0c100d32695741479b8d672dedb390cbd03fd7af4c86afd07f5d1e"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "2043891efe2044cfdf660c307ef21af61797294a643fc1af39b6e6f68e607f2d"
    sha256               arm64_sequoia: "fe323a576979bc21267f8dcd9fe52395d1b900f0136ddca60aed008d5b4dee26"
    sha256               arm64_sonoma:  "8fb2d57bee7a4cd0709e1e83fe464c802a5555451bea4d53175524cef5e7324a"
    sha256               sonoma:        "6c5b40eba6e70852e12f5d099401c08b70011f074a90a5e0910d6c2fc5c8d3e4"
    sha256 cellar: :any, arm64_linux:   "b95a988a3752fd58bd53518dad0e736bcb98ea36857c12f63105c131de6403f3"
    sha256 cellar: :any, x86_64_linux:  "44015d3ebb5af466264ada7b6061f2f9c6f8ec327c394992390b24707ae894eb"
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
    assert_match "Locally pinned agents: (none)", output
  end
end