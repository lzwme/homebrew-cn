class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.27.5.tgz"
  sha256 "dcced59cb7904698c1f21838be50c07dfe2b70325e953f0650140231bd6ad258"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "f116625956ba65ed425675d5908de097a4c5712f31b648077207626d65bffd0f"
    sha256               arm64_sequoia: "43d8db3cb18acd851b6ef27329e4a25b71790b7f01f66a43ec7a16ed2e9e1597"
    sha256               arm64_sonoma:  "675586fe046491a434be64a8679faf796d6bb3f0ab2a37172978429e3ade3831"
    sha256               sonoma:        "0826a900e368410e252ca8d1f1466cf22067fdc64d5525811bebe18e13b47dfb"
    sha256 cellar: :any, arm64_linux:   "aa5b58f5b70dab35ce05a76ee74ffd3480ae39e26ef17947c6fb21a7aa536aa8"
    sha256 cellar: :any, x86_64_linux:  "48f30354b0a721babb9fd3a115e80c00c88bb4aa41fd48058e3fcc30b7fe99be"
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
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-12.4.0.tgz"
    sha256 "c5651a4fa92942a36cf30e0f043119d4889e26e25f30ae28b8cecc16e705bf29"

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