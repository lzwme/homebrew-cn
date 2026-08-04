class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.30.2.tgz"
  sha256 "dc71057c20750738454b6c562b85623e1bee0361634837a98a3cd19651111116"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "98badf4538d8aa4095ac74498817c04f926676235a40fa2b2fc38d4376c33997"
    sha256               arm64_sequoia: "840363d8857e98fb3ba119df12767c5d8b9ed85b8a3d632569317808773e5495"
    sha256               arm64_sonoma:  "1564fdf6dadbfbc228d550e10ae74b55b516f79705cae7c30c3371f371b46e4b"
    sha256               sonoma:        "3e00cd80f0ee35725fbe24ac7bcd06c7506ff7f6040e464b38e11c6eb68a7be7"
    sha256 cellar: :any, arm64_linux:   "96de15b1a721407613378a8f357c3701941ed189f1fd0ffe1b259b112b3d1964"
    sha256 cellar: :any, x86_64_linux:  "6f40063a9551d6a07bc4c95b38ebbec69808e71603049ef1d7c698d1fae87a0c"
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