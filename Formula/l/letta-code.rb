class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.28.8.tgz"
  sha256 "fabf20ca87cad3ba38da1466717aa42a51e9b417ba632028f668ec6f78f92bd0"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "f71c2a95f7c3b17e6231bdff23bbd98052996039373cd7f5ebeb8b84109d1533"
    sha256               arm64_sequoia: "7a3390ce7bbec905b0824fd70bb72c79e57b5bc65c451311a28ae3c81c495e32"
    sha256               arm64_sonoma:  "1ef78fa20cfd24d43ab6e24c8922117895b1b86a29855d8562f23cb2eacda048"
    sha256               sonoma:        "5b195443f8b1057b039e02cae0858c49a8da9e9a99c667be53bc09a89df838cf"
    sha256 cellar: :any, arm64_linux:   "2e23382a7519e84cd528a791aa698e63ff72edf4d8131b84a6d90762b2343458"
    sha256 cellar: :any, x86_64_linux:  "664ad1ae2aeba32c2376fd6d3da6c8b30895fd39e1bcdbaa7e41467d9db1f122"
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