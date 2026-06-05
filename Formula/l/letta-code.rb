class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.27.3.tgz"
  sha256 "3be674a23c5771b82913c668a9980d9621c75dbae3ee1a9cd13ea40be70f87b5"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "5d3642869563cfed093ec281269bf38e0b1169d33e265dd38d9d1a5872910955"
    sha256               arm64_sequoia: "cef5ad25e824643bd82c67528fcf6f6165b7a0aecfac1b551ffead7f98937383"
    sha256               arm64_sonoma:  "01fcf198c44f7b1024b93697af00498fda0856173c97e7401a4ad8bc35945b55"
    sha256               sonoma:        "0c78998056ba17dde50e4b4bc7092bc49a4d9f6a12de4483e5715cd0d45ccb07"
    sha256 cellar: :any, arm64_linux:   "805b749c31f50b3737ee0a761f1a62a759edd1cd2ce4d0049e22bc636ca9d6d3"
    sha256 cellar: :any, x86_64_linux:  "19be1a701cda7d988f5230dce005990bf0b324e86490196028ac714dc0b9777f"
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