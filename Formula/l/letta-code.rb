class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.26.8.tgz"
  sha256 "6ee4fd114d5fbad6b1520c57b21b2ea22b778dfd737c5ae1371b9cffe408c246"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "b9b9681ddfe8d2c80ceaaf1277ed389ef64781a2e99e3be2ae9a27b719f6071e"
    sha256               arm64_sequoia: "7d7807975f642aa3cc8d8ab16011889063fd58813a3413f5ce84d07fc1c82be1"
    sha256               arm64_sonoma:  "db7ce9780627774a5e14d5de8c0e82a8c5e23eaaf0a3b688030d93255315066b"
    sha256               sonoma:        "91f5bea594b0119ed12e3ae6e8cc55c25d77d024e4d58fd2f19220c1ce57a01b"
    sha256 cellar: :any, arm64_linux:   "16ff8c58ab0a6bef6aa0cbd038dc649dd6c5d6809c86cbe356cb31ce67e06d84"
    sha256 cellar: :any, x86_64_linux:  "dba100dfa10aac125c372142ffb6b0d9db7b361038a548541fa3dc8bd7c2971e"
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