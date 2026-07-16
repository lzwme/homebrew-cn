class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.28.7.tgz"
  sha256 "efdf31b1c192f19db01185efc97b7ddf6ad73921265ee886fdcb4de30e694bb3"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "7c1a7d2b6371300d5ca4c3e6557bb4fda9889714cb32a715ea5ab454cb90ca4d"
    sha256               arm64_sequoia: "e4acab43edf9882d3825980237c781f52a4ad0f4c0d1b2a9b7afa3a0031bde4f"
    sha256               arm64_sonoma:  "9a199621de35a4bb68ebc40527ab9d4a70880f843e9e8546b9cf2318dcb83a33"
    sha256               sonoma:        "50f87e8083b3526cd1df88a85bd48666a88ba8847f903f40bc7bdae66528f98d"
    sha256 cellar: :any, arm64_linux:   "fa133e242188add36db4cc3724c8443c0e3d696205ee21f627776ffb93009ec8"
    sha256 cellar: :any, x86_64_linux:  "571559ad7f32feda5c51c7a92a3b0acaae8734ef9420d167d5d003175d52e473"
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