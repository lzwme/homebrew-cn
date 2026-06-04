class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.27.0.tgz"
  sha256 "0f2de4c65a03acbd20cdcb42243c10adf774dd57ed83af5b09730e99ac1bd9a2"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "5c9f6890480ef2ba07210481f73bcba2709ce66a8e3d3a6302f88c12d5be66ed"
    sha256               arm64_sequoia: "2c78e39956a98d296693b4713e2b68dfb6f2435345909598d593db3d6f1163c4"
    sha256               arm64_sonoma:  "fc7744847e3bcb88c03c73f6d18f4fbe2868639381b9e3613358c2dbd782a98e"
    sha256               sonoma:        "e4e8ae64150065c6426455feb165013e7c6f0d8a5ef959ea5ba720a3eeedaaee"
    sha256 cellar: :any, arm64_linux:   "4f5e7f8effe1bd25917945f13e3d75c90ee88ba737428b8b80f70b9bc4c34171"
    sha256 cellar: :any, x86_64_linux:  "dc040f3bfbbf7955aadf541d176bf556665d50b41ee561f130ff01cd969027fc"
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