class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.27.10.tgz"
  sha256 "d6c98b90c1987ffa834183d88cfbfbdf648664917ddb6239dce3635a557bfccf"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "887e5c8d4dc05d44abe42e3ad95edb4d5fd3e684521ed5c15d0a202aee48aff4"
    sha256               arm64_sequoia: "230da957b33a249f0f0b57e6c442304b1629b47236a61089bb64a60d8b508fda"
    sha256               arm64_sonoma:  "75620778e46da7763782cc8c48a799d7b91b595cb683b22185b23abb82256026"
    sha256               sonoma:        "6c2af23f2481769ee02db4e4e277f262d98a54bc60abab1deb41a07c4f7ad554"
    sha256 cellar: :any, arm64_linux:   "4c044608605cf1daa0b4dc5d622b48a9dd7aaabb75134bb73dd9c9edebcbc1a7"
    sha256 cellar: :any, x86_64_linux:  "0b8cc490bc7b255c5ab2aaeeac0b43fd2c6b9f9c341663a9260ed433e0b18997"
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
    assert_match "Locally pinned agents: (none)", output
  end
end