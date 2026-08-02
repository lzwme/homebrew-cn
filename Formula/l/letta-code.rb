class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.29.13.tgz"
  sha256 "ce430e8b9ac6ca8c87ee73f6cc81e6d7bce0aef2e6100c129630e9ac6b0d2c17"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "fe734603b8ae25661761aab4b25941402cdd75693fcc6892a0d08a5dcbe700b7"
    sha256               arm64_sequoia: "9617018e134f7f3549c881dd1fc9b341c811cf56e402fff0973b7e93465a332f"
    sha256               arm64_sonoma:  "112e193baa2790a3d4c75e1ceb9dc8f1d258de12a0d5daae47750926ca6bdd39"
    sha256               sonoma:        "e6074a2992756bef272f755f4ff97565f756eb32b4fa73bcc18f183888fcc5f1"
    sha256 cellar: :any, arm64_linux:   "df860407c4d6c03b980f3ae9166aecda478b268bedcfc174623d32713541302a"
    sha256 cellar: :any, x86_64_linux:  "d30642fc1f1fa837e92db0ef60285b7ac6ca3bc2a8a1444fa2dffa354f74aa46"
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