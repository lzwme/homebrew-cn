class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.27.16.tgz"
  sha256 "18727dfe5ad3cb316689acea0cc102e5d992329c9ce570ce436e45cad0b126f4"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "ff4396c4e0f66e455b499224516646334bf8224a3af219421a779e99cba17fa2"
    sha256               arm64_sequoia: "af2dd4084bb28f3d98d401cfeebdeea56ce38ff11cea6fe7f3a455cbbf9781e9"
    sha256               arm64_sonoma:  "f03e276adfb18998db5c0a16acc7c3ab3f4363c9a07be4077ad12f54e429df29"
    sha256               sonoma:        "a62a0680565167cfe836edafe4070c309f43286c25807f31a9a12f75e3002807"
    sha256 cellar: :any, arm64_linux:   "cec9cffa63a367df411aa391ba5096f789a8e63a2ba97a2e37eea7eb7b7357c3"
    sha256 cellar: :any, x86_64_linux:  "03726df2bb47b67993be1bf93a45ece6a3651ff5de9523be88c2c0a72205ad6c"
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