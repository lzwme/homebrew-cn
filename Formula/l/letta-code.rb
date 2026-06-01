class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.26.6.tgz"
  sha256 "3c30b6ff7793069c776bfc37190f27da6292976a85e9efc31892318f821a71a8"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "734f685e64d35743645ff5153b262dddc13491d3632590f52083ce24cc322689"
    sha256               arm64_sequoia: "fa7653a4c76bf722cced2711f2ac50760bcbe990f03fd5de6866dce0e6c88913"
    sha256               arm64_sonoma:  "fe8bc7e423cf07f6ee6165f3bad6de87e2f803107f5c46de8815c376852eb853"
    sha256               sonoma:        "2ef9b967d4dcf2316f65b2ddc1cc2eb2bbc8b91071f2bf94ba87354723a3f474"
    sha256 cellar: :any, arm64_linux:   "cebda5cbaf5d6d1df966ecdb8bd8684dce93b7762ba2fee43fd1e4ce106a10f8"
    sha256 cellar: :any, x86_64_linux:  "61ca6d02708182e1f1470800a85f1d5bb2ca5a604bf9b9be8c4b21a15fcad421"
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