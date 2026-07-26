class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.28.18.tgz"
  sha256 "9e61f5d65a832252b6f2b0de39692379b6ffd1d00190a7ae64f027d85d8b5783"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "bc211fc9ba105e0fdde54191d63277936040f743775f6d52e589b7096f1eedbf"
    sha256               arm64_sequoia: "197d14be1aa227c6b09812c35c74ba7db65f78842ed93bc40e1bf44dca6a8e6e"
    sha256               arm64_sonoma:  "cd12824cb33bdd6f2270447f4360f93606e89e1525bc7fe3fb1aacf94c3623a4"
    sha256               sonoma:        "be39d9dfacb3ba262e38e382b48210c206d2c08c3aed57512614b545d2922d08"
    sha256 cellar: :any, arm64_linux:   "8fb1fcfc7b56501ca4e003496119ca72bc72b780b6d1fb756d52fefcef313616"
    sha256 cellar: :any, x86_64_linux:  "7c4420df5feeef6e263e0c2fc6410f9dfe08c710edac85fc1776423bcc3cd38c"
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