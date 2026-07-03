class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.27.20.tgz"
  sha256 "38999aa7ab1228b574fadf2f1339382abe7261218343df1fe041ccc89ac71352"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "7d902a04cdae905f34743d25b1038f5585b73e08bda72d481a048217490f4284"
    sha256               arm64_sequoia: "4ae4e49c2f5f47118ce9778cdb622abac9e4b6d9990f8765827c0c41c0002eaa"
    sha256               arm64_sonoma:  "baec60bef27a3ed9e0d1b6b5405bf3b2c7c9e83e6a64036d5b5b5a269d5ec542"
    sha256               sonoma:        "677c168423ad7107a6b277c8a0a21c1d7d7afd598ccd12b6e347c991a1a67a9e"
    sha256 cellar: :any, arm64_linux:   "aee829e0c4b3b51773db2a3ad3f8d42e36590018ef964ce70e15a61760fa9557"
    sha256 cellar: :any, x86_64_linux:  "3fb2c9b34f27cdbab77e64bcc61ce6d4f5e1d67720389c17167470d17e015345"
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
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-13.0.0.tgz"
    sha256 "10e45f33997680c9ea6ebfb8c575aba66bfbe8ad9c782a7426a37440b28b62a6"

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