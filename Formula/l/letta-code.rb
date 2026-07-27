class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.29.1.tgz"
  sha256 "b9bc78d2fc56b29e071732df8c1cb9e707cd4ed806c3cf284b13282c851dc23c"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "cb70f29582ee1334b45f2b72343ca7abd50d2155cbfb35e80c4c454fcfcaf5d1"
    sha256               arm64_sequoia: "e041ab9426c8c9bf0932143c4e773cfef6c8fd4cb75c74ec07872b9ce8a07444"
    sha256               arm64_sonoma:  "e0c9ebc8f78a72ce7d89fd09f5832337a48ad0a3c50eb53506f8ea84adcfa336"
    sha256               sonoma:        "25dcb8235cd164f9e21771a7dae16a2d852721fb5d9bffb7c5d83c7913af6653"
    sha256 cellar: :any, arm64_linux:   "e6727dffa0112614d49f6eced8ac06a0d05ee13d12fbbe48b217a6a29c91df23"
    sha256 cellar: :any, x86_64_linux:  "747d0997384543980d6894849fbac9162bd4909f65de04dbf7cfbb7763ce285a"
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