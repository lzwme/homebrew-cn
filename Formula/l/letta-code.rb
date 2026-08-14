class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.30.19.tgz"
  sha256 "9f8926afca45f75e5bad07bf14dee6147e7c24d37d1763c8f25ab3f6b1a45eec"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "9e9139f877f6bb9eedc1a04c8ac159ce56fa04733efaf07c2ff49cac633769b2"
    sha256               arm64_sequoia: "7adc903d3b061ac2e4114a485b52c467b93fbb970f19e5d361872ea1f45ff081"
    sha256               arm64_sonoma:  "cb3310c3096f454381eb4a878d440225a6e702972737ccfa01555211aea4aa60"
    sha256               sonoma:        "7491e1153d7641f309b6f88fabcb3cb65dd2161f81de3f123da756d710241726"
    sha256 cellar: :any, arm64_linux:   "1ee2fe7633f4afe3d4a93db6dd888654a04b21ee7e93d00c694e15fe52d2735d"
    sha256 cellar: :any, x86_64_linux:  "83110578e34fabf2421090f2295472de92293443ccb468914ab46097b0cbd654"
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