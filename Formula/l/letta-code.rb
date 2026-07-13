class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.28.3.tgz"
  sha256 "82293545120fecd9adb78550b0f08ad16054651d895b53400a51a04750684b0b"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "c63dc7f73fde9a61f0be50726cd63b453a68f50d5758b6bb7d521799f4efcfcc"
    sha256               arm64_sequoia: "1c5ddd27c51e261233816465af0472c61a4cb714daf7665137f5e282f1fcbef0"
    sha256               arm64_sonoma:  "d37b020f1ced1dddff501801b13db98870f60a9e7ade5c0a32668f4e5d8bb62b"
    sha256               sonoma:        "3e9c1e7ff62f9cce378134649352c67d0c269dc5be7f2cd597b02843b647af3d"
    sha256 cellar: :any, arm64_linux:   "d491069e381d6013b1c9c5216882d8d73de6720c963d849d815096551a12b5f2"
    sha256 cellar: :any, x86_64_linux:  "035b35c8990cfd6db453fd8cac47e25679d76e7c8bdbf3e1e899fcd007e17f38"
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