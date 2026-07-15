class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.28.5.tgz"
  sha256 "928d29f0906b229e79ce5faf855a4c620734d8b50c3f720d408db01d692cc646"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "bbd7c7ec06d41dff90050a4ee21c161313bc251342046702472bb8a58974dce1"
    sha256               arm64_sequoia: "19ea08c6354277f48d34bab4a8aaf8b3a90d9453c9939b41e1c528f7d860264c"
    sha256               arm64_sonoma:  "058286a6cf131a8561038532175308d16b795214efc1a1ab4ef1b1c63de88e81"
    sha256               sonoma:        "a702742e3e231d4e1d1841c3e783f3b86b8064c90ba55956cff058e72258f506"
    sha256 cellar: :any, arm64_linux:   "fa935528c914b17d2c3b108fe6a2eb9d690e6701a3dc3f778348c2d09b7cee53"
    sha256 cellar: :any, x86_64_linux:  "2f7f063fe867ddafd9f6c99755a5eb9316ca263bc26a61ea804c610b0eb79327"
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