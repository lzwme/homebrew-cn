class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.28.16.tgz"
  sha256 "1449e37edb06de21b8300b0b065b3d0284a37aec736a3e593291290c08e22182"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "437600186ae017a0d50e7b45f6f06153c800437ca08820ea830c528ca3f2151d"
    sha256               arm64_sequoia: "747a66e76921b8df646e891d7d57382692baebacec3304fbaa6a3928808c86d7"
    sha256               arm64_sonoma:  "6ffbff6947362569bfcc4ebc2002d763f386adeb16c80319c603a19eb4637572"
    sha256               sonoma:        "86c7a435a8b4e4cd4e11b7de493b10932845e019020d8c778c4d9de21c7e2626"
    sha256 cellar: :any, arm64_linux:   "d9d9ac495e1bdb10fae3a76383e0091dd505205427966f71646299eb75d78014"
    sha256 cellar: :any, x86_64_linux:  "3b9dcccab944f30f5884056d9c9fba0cc24765a8a5b17be7e1743de78b7a70af"
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