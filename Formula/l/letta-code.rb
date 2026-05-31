class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.26.4.tgz"
  sha256 "9378cb77873b9cd04ff45003dc47dcc684466a190424981c93f668b90344e784"
  license "Apache-2.0"

  bottle do
    sha256               arm64_tahoe:   "736f07f70da6154776bd9ba5cd7589ad4a0978a8bc642dd86635797e7c9ce076"
    sha256               arm64_sequoia: "cf6d8bc255c93d1214abdb349b94b252f4c5a99a518c0313eac9890941107ca0"
    sha256               arm64_sonoma:  "f4110fa056231a961eb9105463dd3135fcf42e2408b69e2baac5603d00847575"
    sha256               sonoma:        "72415769a8b95a8e2321ca1d732409457ba52482073041af6eb99a8427cc2e7a"
    sha256 cellar: :any, arm64_linux:   "b9ae9400f34d7d1880ed1f63c429936f71ec62800abc33850023b3993ccd3dad"
    sha256 cellar: :any, x86_64_linux:  "4eb8c30ba5ac4023f055f9a82584de413e2942486f1f26e774f6b7ef280ed126"
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