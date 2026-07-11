class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.27.30.tgz"
  sha256 "b32e0bf923697149b77edeb3ad4f50129458a4a47e08312057d8ab442f265aa0"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "8d6fb925e6e847b495628dc64bdc9f649bac34eaadd20ee8ed4ca220961c8f48"
    sha256               arm64_sequoia: "44a35b7be5d0aff21a10e444cc918d6401ddc0f9dca4b569a2c559a3fc825cad"
    sha256               arm64_sonoma:  "e8ec6f6826685c199393b7f5dbcae8482f8133451dda7b27d9d6606bf4023e9e"
    sha256               sonoma:        "5a40a040ee20aa41399f948c27d81872966fee1846396e6276d8eb158a435eca"
    sha256 cellar: :any, arm64_linux:   "1f1bc7c001acef285f9524a14c3b2e66844068461f9d78f43820ef3f3ee02d99"
    sha256 cellar: :any, x86_64_linux:  "c7838363d78b1a62231bb8988f7b4a2e0a36a9f784a6551daf70dd1676ddc5cf"
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