class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.28.13.tgz"
  sha256 "9327f31fd82b11ca787a4a717e9abd33e47b27df55c210f787339424700ab8c0"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "d8e5fcadd106a708321927e04e8cee199c1640e3a4ef270b9c22198366d0dcc1"
    sha256               arm64_sequoia: "ab2cc2684b694ed86acf15c84a4f155a9fe20e4573d6a7e12780d89435f46d4c"
    sha256               arm64_sonoma:  "b8fddcbfd91b7353a592a57afad41a3864529fc712718e6d382fae9f8c2964f1"
    sha256               sonoma:        "197e78dfc3be86c5382641d0e387625755b3cccb755fd5a887a105f67101da0b"
    sha256 cellar: :any, arm64_linux:   "b722eaa4bf4b502715494659969e3f33e3e0e7f1ef3488b6a43edeeefbefdf0a"
    sha256 cellar: :any, x86_64_linux:  "fc691f5a49b184677b9cefe971dc173eb4fb3e9361735e8422924a318cd82127"
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