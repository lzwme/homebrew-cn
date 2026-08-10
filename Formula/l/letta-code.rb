class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.30.11.tgz"
  sha256 "2f9c7e40f687cee951c5c0f77e1283b62c8de59d8b37d00bd92b6aca5600072e"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "b15cdcb2f8dc7e787d24394182cf4e8e18bb61467c4e47716728cfa6f5d77d4d"
    sha256               arm64_sequoia: "a960f2a6bf053d40d3ee23275b04aa8a3b1d5fd550e5eade4127204d1880fe09"
    sha256               arm64_sonoma:  "ff5b1481d6974c83d581292a8c325853148a899da81dc8cc301fc57e663f3b53"
    sha256               sonoma:        "1ca39607c1a6607d6fa4f8e3b8d6e58d20578da22c0d687d36a859e5d0b89f3f"
    sha256 cellar: :any, arm64_linux:   "54fec97cedda53c8d49319f795c9869388a168290ed57e2f73739da1165a89d9"
    sha256 cellar: :any, x86_64_linux:  "9a419605abbcadcdbe971d72ee27c1bc21560e138d97961a26efe9edcfc739e8"
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