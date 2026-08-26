class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.30.30.tgz"
  sha256 "235e57dede8f6d8bb05e6569376c1716e1f4e91dda992d91941f6dc650527676"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "22e605abbdac516e10de4fe03ea0820263c207710f39a83c12cd02ee9697edd2"
    sha256               arm64_sequoia: "38a2c3b7764a54822f1f2e07ebe27d0ead9f96fd6d51f48be597c62ae6e5dd84"
    sha256               arm64_sonoma:  "e873f3d720a4e41eda63a51bf1d5df50ac669f3c5d01cc526547ba7ec7740b95"
    sha256               sonoma:        "c3d9e018c98d3c5b57a96a56e38fdf59537e830a02f0baf331a56683ea23c4f0"
    sha256 cellar: :any, arm64_linux:   "9e2ce117e6a8dd2ca464b24fc5c00abd506262a6d9a397784670380a60052687"
    sha256 cellar: :any, x86_64_linux:  "9b9c6561bbf3d29337c2149d8d83e5e0246a6b736644f5a857bd522d6667dde2"
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