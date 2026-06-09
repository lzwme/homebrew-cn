class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.27.7.tgz"
  sha256 "5e33de69be9d98ba022e4a96edd497d8e0db3add35f06965f7130b4290d575e6"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "9557a8698754191db0f97af9732d99acbffaf43d582c31b7490ba90efa92612d"
    sha256               arm64_sequoia: "2daec90ed2e1b9e31c46a6650b19f758b7e71fa8986c83e7e1ab91a66471d8e4"
    sha256               arm64_sonoma:  "45d78c912b78cb4bbb949e63679e97d392fa1afcbb98b6755c2bd3ac40db2572"
    sha256               sonoma:        "9bdde446ede7b4aa56077dcb8891d7fd76ff1a5333e7beee1e24f941a868cd56"
    sha256 cellar: :any, arm64_linux:   "0d00b351eae940f4967d58285019482b795d7a84fa0f0bc829e03391a8b3ba0a"
    sha256 cellar: :any, x86_64_linux:  "f908962930f7b2963013b4d850c3d5166154065df3aff4217be85885d4eaf70c"
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