class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.30.5.tgz"
  sha256 "983f2ca7f23d40fa8cdc373d22b0abd7da70cdec1dda098e8d597d5741aabb0b"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "d98f04f5beed6c6e8c7fe4c82e8e9d1fe1ab89bb40645c5bcc6d4fa42f733d08"
    sha256               arm64_sequoia: "f639dd0e9407b1bf91e3863cccc10018e249589fdc102f3d8e9866b65752cb8e"
    sha256               arm64_sonoma:  "bf9ef603ce81ec91db1c67cdcd96cdbec21df94bd45723542fb8b64a15bd4c06"
    sha256               sonoma:        "e6a82190cb396a01aa0016542270003eed3e1f78ce21b84ebc4c1730a359ddbd"
    sha256 cellar: :any, arm64_linux:   "054762a745fc6ed08c4d5e73994554ae49b7c5e2553b09fa746a4bf62ddacfda"
    sha256 cellar: :any, x86_64_linux:  "05ce3ad46f4092f72ef29a4360357744d2cc4c991455a6a4e550f04fe08b34f8"
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