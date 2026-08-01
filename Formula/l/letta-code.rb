class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.29.12.tgz"
  sha256 "dc3d8937fd79fef43afabb9a854c5bc301ac7acc30dbd7c3bde7234d67e6a57b"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "641547f941ce32c94e96595f9ea9ae08a893346856f1d49b6c160ac590c7417e"
    sha256               arm64_sequoia: "80d3bc8ede48001f5272fca20f0278bc04341f62f0eeecf834f9db5368f0beb0"
    sha256               arm64_sonoma:  "b43dff8756716a1a0545d390439ad64c7c2d05e8dd8d6b00faf642e971c35196"
    sha256               sonoma:        "c6c062437a7f33be17c45251c16e122acd1d6f880ac59b8db72d4d3e34efcf5a"
    sha256 cellar: :any, arm64_linux:   "41aff02a3754921152e1f3f9253227fba610e588e37a2de9f06197c40f3dfebd"
    sha256 cellar: :any, x86_64_linux:  "f71a78705dea577cf0653ef3b703b491eb949017dd526f182715c2c107d2f08c"
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