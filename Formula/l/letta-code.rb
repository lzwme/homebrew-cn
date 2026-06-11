class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.27.8.tgz"
  sha256 "6bc5069d840d78c9862a56c60b477ba23351e40d268c4e11fb2ee391926f9073"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "9ae825860d1e42ecc593cbae6f27e6815de763aa12b5ab2d5b78c94cafbb0b2c"
    sha256               arm64_sequoia: "5dcf32b9cb9dda26c255f50f2a4b525aa55a5a5a3b29e9ea19eed41ec8eda5fb"
    sha256               arm64_sonoma:  "8fe754c1f4708650a5cc546219fd49c8ecb8d9b49db429d7f4c09d96683e20ee"
    sha256               sonoma:        "f67a63fe5b05214fac8692ef539b723410738aa25065e72480f25c5525c38d04"
    sha256 cellar: :any, arm64_linux:   "38bb1b7ab97277731c5323312aff8358095e3f40de375ac48368e7bcf6eb9b32"
    sha256 cellar: :any, x86_64_linux:  "af8b643677d3edb202f26a50fa47ea440f1184e8854d7243d742813542eb083a"
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
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-12.4.0.tgz"
    sha256 "c5651a4fa92942a36cf30e0f043119d4889e26e25f30ae28b8cecc16e705bf29"

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