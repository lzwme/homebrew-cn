class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.29.11.tgz"
  sha256 "fcaf4ee0474e130058828753432769b7de3e4b080b5958e285604e40c690fa2f"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "a44fda439159fae8d00e063d8a444133b2a50c85d063965df8ba12613e4c3af3"
    sha256               arm64_sequoia: "90c28a2c26aa43302ecf4adf43c16c796cefa76920faaefd648f38df91aa3741"
    sha256               arm64_sonoma:  "56ccc383d774d5a601e57663c29be48e817130789d20ebca2df03273d49116e6"
    sha256               sonoma:        "91a6742f97f84b114b80d46ca46c663f5c29ad0c999eaf61ecc7bde7fc77dedf"
    sha256 cellar: :any, arm64_linux:   "40e6fc3b34204ed7693afe6fc5ed416c747e785628875cbaec307425da663060"
    sha256 cellar: :any, x86_64_linux:  "e06825844d4968ae51ffcfeb6104f4de5ace9a4c6fe7de8f877ad80840f41121"
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