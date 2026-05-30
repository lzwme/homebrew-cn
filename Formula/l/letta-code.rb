class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.26.3.tgz"
  sha256 "a3f0e7530df78ca55f9920245dcddb7e0b80766f4e5d6e511d1801043cf2661a"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "8d290f6705b8bc15285bea7de5a91a35c81a0cb6a078549dc6829f706d1d92fa"
    sha256               arm64_sequoia: "27986b195e073f17f3e52fc2e5c2b6467772fa8ff5297b40d310d0e6f6067c8b"
    sha256               arm64_sonoma:  "8b51c99a8c1f88f4b616b94e61d62f8d4d996be70c118a3b77b63ca48425de71"
    sha256               sonoma:        "8298f7ac348032929e2b3f8a8d640160f6048236f4f4fca6477e29ed8506ee7c"
    sha256 cellar: :any, arm64_linux:   "fe85bf073cd236fc88eb603eaaa9a8abd8d38a465c933f57c9e891aefad743d3"
    sha256 cellar: :any, x86_64_linux:  "11ec92bdcae2ad7bfbb8d3db0504d902b5f1e38ec81b914246fd2737b6ed7232"
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
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-12.3.0.tgz"
    sha256 "d209963f2b21fd5f6fad1f6341897a98fc8fd53025da36b319b92ebd497f6379"

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