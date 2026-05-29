class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.26.2.tgz"
  sha256 "f53dc4e965c52281c8ccb46d6bcd137d0f794501cd4897cbfd39ebc04fe0d0b9"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "3483e86b66bc39eeaa9b60c11f2c58849789feac188bb74b8900d8e20e17e282"
    sha256                               arm64_sequoia: "3efb808ab4100c0157b3b8933f6a62a188a33723a34f2cd67687d3a7c2fd9012"
    sha256                               arm64_sonoma:  "316431fbbf7b24fdfb4bb82156287a48cd50d337a9bea73373b089c1ef18c128"
    sha256                               sonoma:        "2f696ce2b8bd41d8148dd1f61a71df24d70b31acd6eb8df475c786f4951ab5ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40c6661726ab475f2731c67297780be3070231ba9099a61a7c9972e5b3b7b345"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb024d6103756d41921ed19f917f683a9787e422f4e52fde2a5145c4dfecc23d"
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