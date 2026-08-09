class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.30.9.tgz"
  sha256 "be7a459301f4adc5c6e9a452f779ecb9087ce65de60ddb912f9b238d9c32a56f"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "182096b8e59843e3e3b3c1e5044a3e60fcceb7013c4398625032303716c1f0d9"
    sha256               arm64_sequoia: "ca45e03afd6897df8a6b9e5e1c4c8bb1c81e0818f12de885297add9a984c49b2"
    sha256               arm64_sonoma:  "8c0606535e8f0192763458032e4d5268d1e64901910ab4bdb0eed6221d8b4506"
    sha256               sonoma:        "e640af7b37e8a15e053fff725ac67976d19c83a6aeb99826528cee0b2952e444"
    sha256 cellar: :any, arm64_linux:   "56777a3cc76e23153a6e014254e4efb53401d98c136b8727f7e6c2a2e4799e13"
    sha256 cellar: :any, x86_64_linux:  "ff33b7c3e37b06e65b0c4ed5dc6fee4dfb2988b543b6310a06739ca71eeb28dd"
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