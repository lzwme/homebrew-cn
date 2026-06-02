class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.26.7.tgz"
  sha256 "4b65dc30f5a720ff7f2829bd1e0f59dd78ab0185c13123f791e57aea1ed47ecd"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "e4cb15317646f86e2e78d9a9ad3a3fcc58c58205b4200fa6939e4dd40f4bce06"
    sha256               arm64_sequoia: "66c379c1cc8885a7fc93e9729c7755eaa3117c1ec974ff0826a3746dd677b7b4"
    sha256               arm64_sonoma:  "ad6ac55a4995b78093de7c27b5f1c1fd1ecef895d81d7193b3783e36127c6969"
    sha256               sonoma:        "5069de24bc3eac8e5279b3f3d5d26f873746a55e8509af65b15958a7ff14a330"
    sha256 cellar: :any, arm64_linux:   "1aaf6dd09a819ca809fadf2497c3cacac50dfe4729c1772169f215123da42d40"
    sha256 cellar: :any, x86_64_linux:  "c76fc3b4668dd5b125aa3df93481b62cad4320928f8567b0e73f833252b557a4"
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