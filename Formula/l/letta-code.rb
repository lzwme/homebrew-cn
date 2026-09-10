class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.31.14.tgz"
  sha256 "0b3c3ed3259e66222e788699f13f3c98344d32c6bfe72b58742115652f381247"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "e556b666f392080d9124811f3d1a33dde5944ad330c4dc05d0e2782f14e14a8f"
    sha256               arm64_sequoia: "b85ec822dc8d08db7b6eecf55642bf25019a16023e567675db301efd9aff69d7"
    sha256               arm64_sonoma:  "de01879b0589a94f6bf52c0417bbe34d3ce82b174e552fef889710a91856760a"
    sha256 cellar: :any, arm64_linux:   "fb5335bb87cfe9057936b6d00ddbf6611a153335c5a28ab5c5b1f78899974986"
    sha256 cellar: :any, x86_64_linux:  "ca0d5b3a1a786bca40ea5a4e009b8b7df44dd472448d243fa458d45c7152539c"
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
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-13.0.2.tgz"
    sha256 "1b1524d914331bd01312729e31a828192d53af84e113dacb6e36afabb6c21a6d"

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

    # Remove Electron-only sharp fork with x86_64-only pre-built binaries
    rm_r(node_modules/"@janhapke")

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