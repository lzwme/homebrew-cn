class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.27.14.tgz"
  sha256 "14375fe1fdcf7e4cab620f9c7a42d811ce6e265c6666e916a09b49077f190233"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "83fba7816b50a3daadd8b998f773bd3b845585a9540cecfe9dcdb1c5e681f0c6"
    sha256               arm64_sequoia: "0e244f8ab112d4693bbf28835846d60b6f29e8c8f7c16452d9296bd560182e71"
    sha256               arm64_sonoma:  "17dce6b6eb6ceeff3d7fbbc5ec825cb5bce56fc3a4966f46e7d81d7e2577e68e"
    sha256               sonoma:        "b6df6c2f863c2950ab13227ad39b2f38aa684b8adb9ffb0770b3a18ab45edaf1"
    sha256 cellar: :any, arm64_linux:   "f7f8d9f95fab77fe7e577621fb0b4e02c3a7dca7307670427e19c326dda2e661"
    sha256 cellar: :any, x86_64_linux:  "6a5b0ed3fd975c7e93617a8ebc063dd859de0595d37322a363de5725c5afdf14"
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