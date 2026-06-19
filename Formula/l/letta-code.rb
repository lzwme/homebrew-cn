class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.27.11.tgz"
  sha256 "4735d9c49c3679d8e80be02b1340c9d5218ec3065e12afa7de6c37f16e472b5b"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "0fc7593e5195c107bec7a8cede2c13fbb66257f584d3f3be2f1255178ae5d29e"
    sha256               arm64_sequoia: "307db01409eb323b787f7ec75e60054845d525dec5c7771dec6822b787717bd4"
    sha256               arm64_sonoma:  "c97e06efa08ff7f4d544693628d02aa53df6c56f8ad8a4e051bf8195dc166ef0"
    sha256               sonoma:        "3d4f38764b887bd582c67b1c12c8dd1825bf679a9a7f26b44f4f11414e780432"
    sha256 cellar: :any, arm64_linux:   "00fc30694200cb2ea4e702b8e034284997d778ae31bc7bc35a98015143c9da5a"
    sha256 cellar: :any, x86_64_linux:  "607c9f9f1c25a05dc9a306f2bb9328658194e465d82ab4b5aa4451522fb1000f"
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
    assert_match "Locally pinned agents: (none)", output
  end
end