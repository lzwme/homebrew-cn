class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.30.20.tgz"
  sha256 "886d39ce68732e7a8221b6727d4d52f45d45dcbada5e8d66cfedf152e0b39a3f"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "6e4322190e7c260fffd4b9ad154871cf977f71c5cdf10407c01b82a61dc4e57a"
    sha256               arm64_sequoia: "71dc4da53d75a4dc4505966508b18c8afc2ade8db080c0ba944476ccf6c04ad5"
    sha256               arm64_sonoma:  "b6d1e3d71bf43801e63abdef3a1264808bc904b4ac0fc27af07a72e06b509913"
    sha256               sonoma:        "35e28eb4038f7e5a6b0c016128516dfd381a918edd8e9864d038c6d5713b80a5"
    sha256 cellar: :any, arm64_linux:   "22e39b521f8c8578e0e394c8b1037248e5187657e9786144aff43fd07692a6cd"
    sha256 cellar: :any, x86_64_linux:  "8258937395ac10f3f9124ff3b0785172e528add59793ffdce406f1ac2d787eec"
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