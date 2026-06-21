class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.27.13.tgz"
  sha256 "58b87bfbda0ca53a0924c5657004b6fb4716b0b4a12c10c1f03591617297d4ca"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "ca6c487143fa0df3db04968f595bd5c3cd8ee279b624c6bea335cf43fbdc76a3"
    sha256               arm64_sequoia: "ee104d4da03261562a6c246733b6a3f712ebf4afcff64a8e037d00c0b4edf457"
    sha256               arm64_sonoma:  "59e360f0697af97a25b3dc803d68ee9287ad23eca476ddf4a212802616909792"
    sha256               sonoma:        "1c71750bb92f92173038c8e58923da7c183390de07fb7286afa07470462e074a"
    sha256 cellar: :any, arm64_linux:   "23b04467efbea0e4239c6ae2982d8ea0b956fc37f587ef75b35aedfa31aeb02a"
    sha256 cellar: :any, x86_64_linux:  "8b6e0c2d6caed003b194b9d7170eb0f4624320f463e4e003fe4289a0c1f1471f"
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