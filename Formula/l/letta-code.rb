class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.27.19.tgz"
  sha256 "f1574e3dd12fe3f6adff91b7a1705104130bdefdfbfbadea2040f2a5ae49f0a5"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "e20a5a9d879b9bf2fb6506d196eb7f6947e81259910c1cd3a29c77d5129cfde2"
    sha256               arm64_sequoia: "26321b3838caa4c4969834f705f2d3f6a753f293573a2092d9146a0ad3745e08"
    sha256               arm64_sonoma:  "9869c2e0081ab5b9a5eda3dee7c3d891c7b118547711f76e5e5b2752b5656657"
    sha256               sonoma:        "755955b45c79588060c3db7a04a2d533d9bb1e90413a9f38b406b1faf66705d5"
    sha256 cellar: :any, arm64_linux:   "87f0c2a6bbdfae891364d474777e04cfc714b2b00f26ab5e09252ff02211e7f5"
    sha256 cellar: :any, x86_64_linux:  "885a7c237a1fa5b17978f1807189eea1b88adf4c02068d01c302a435b5bd1ace"
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
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-13.0.0.tgz"
    sha256 "10e45f33997680c9ea6ebfb8c575aba66bfbe8ad9c782a7426a37440b28b62a6"

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