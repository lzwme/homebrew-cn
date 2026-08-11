class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.30.15.tgz"
  sha256 "afaa200527aacd323e01e2600c8b8639281d15e398a11b7210904526345822bc"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "aaffcbd952bc7f8dd50b0c774a6720b2ed45d3f5bcf73c6627f53273ec11fe0c"
    sha256               arm64_sequoia: "76a181ff5bae48192ff467bdc5800d8f0f7c3985767eacadfa0e8a4e0da636d4"
    sha256               arm64_sonoma:  "95531865b6d4e44d8f076969e3674a6881f2ab148d8c2167aba6acf5f30c8c17"
    sha256               sonoma:        "40aba03b0dbbff7af8f65928489882ce1722547b4f427fd27a9edd8232fbbb31"
    sha256 cellar: :any, arm64_linux:   "0e4d505b0f76a2b622aa126a026bca4525987dfa638ba246ced49d9355a4a023"
    sha256 cellar: :any, x86_64_linux:  "39f1cd66c020d27bebeafb4298fcf0615c743ee6caf7faffe31832dd0bd2db8a"
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