class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.30.26.tgz"
  sha256 "44a0d7842cd55c7789d478b52e02dbabff3af88ab2e822bacdf27cc60d231f18"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "99207116fda5ac862ab0775ea9e694dd184b9252c133fd40a607db76a63b1a5e"
    sha256               arm64_sequoia: "eebd414f0611d9c93227b276468a9d3650bb57c611a404f2458eaa696ea35fa3"
    sha256               arm64_sonoma:  "60c1c226dc1b88ebdbdfeb156fd51fbb243266e814408bce253540124b838a1b"
    sha256               sonoma:        "1810575e30b4e669c4e09a9771c50e627e1a40fc48a3775dd82fa3b3ee1fda16"
    sha256 cellar: :any, arm64_linux:   "17b331ea19fc8f06affa87a11be47af2da1eae9f618e53c3eef1d5de327fd8fb"
    sha256 cellar: :any, x86_64_linux:  "39d34362e7dfe3a70c8dc4bd87f1b5d0255a79526e986feeb7a382af2a255f38"
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