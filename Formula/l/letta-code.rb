class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.29.3.tgz"
  sha256 "c36dc671c38a5226fd7c72969844da746f349c96ba57afc2b7e2b6ab77473ec9"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "59df497663d98dafe4e28b1fe902521e9587724fb729e30612ccc12fafac7d92"
    sha256               arm64_sequoia: "a5b40e10f9703b59fece349dabe8930de785536ba8818a74f8c458e424e932f1"
    sha256               arm64_sonoma:  "353bf895336a173421fb11c7b33e5767fc91c1e4b91382f14ee74983af8ce196"
    sha256               sonoma:        "45ca7d01eff290d0fd880c633a113000f68da0c8ee16530841d43cccf27610ad"
    sha256 cellar: :any, arm64_linux:   "598ce966cda0ac2db02932905d65e4a5a10b8dec06ee10104da27e7df729a39e"
    sha256 cellar: :any, x86_64_linux:  "7ea7b833725db0937bf2aaca24fc43c1a3de5edb5f95ef63ca4f2d61062ff244"
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