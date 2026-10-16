class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.34.14.tgz"
  sha256 "7be903c81277ea31ec91b436d9018ed1af7a72a19d85e5541097c20cbbe9a7c5"
  license "Apache-2.0"

  bottle do
    sha256               arm64_golden_gate: "1a2c5855958fff47799dd6ec3940f305f3d7f753b9263ca5c1d4eb805a00dc94"
    sha256               arm64_tahoe:       "5c64e032cde63be54d2e8e39da39442876b8a39982a6bf252efb3fa324e1edbf"
    sha256               arm64_sequoia:     "a4b3ed636bb664670e2cb0a9ea32caa1be9ace644f1f89b4178dec60f616bc96"
    sha256 cellar: :any, arm64_linux:       "205c0daafc89d53d626a7ee0cf46e7d49eed1dd628c73c338d10a1fab5ec8a13"
    sha256 cellar: :any, x86_64_linux:      "18b2a2934ab3e927ff5db1fed28e5104d541820c990266c327eb0ab9ec2b1084"
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
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-13.1.0.tgz"
    sha256 "15663ca4944844139023390f057e86f1897d855959ea7e96f151d4873be8c71f"

    livecheck do
      url :url
    end
  end

  allow_network_access! :build

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Include nested copies installed by letta-agent-sdk.
    # Remove ripgrep pre-built binaries
    node_modules = libexec/"lib/node_modules/@letta-ai/letta-code/node_modules"
    rm_r(node_modules.glob("**/@vscode/ripgrep-*").sort.reverse)
    rm_r(node_modules.glob("**/@vscode/ripgrep").sort.reverse)

    # Remove Electron-only sharp fork with x86_64-only pre-built binaries
    rm_r(node_modules.glob("**/@janhapke").sort.reverse)

    # Replace node-pty pre-built binaries
    node_modules.glob("**/node-pty").each do |pty|
      cd pty do
        rm_r(["prebuilds", "third_party"])
        system "npm", "run", "install"
      end
    end

    # Replace sharp pre-built binaries
    rm_r(node_modules.glob("**/@img/sharp-*").sort.reverse)
    resource("node-gyp").stage do
      system "npm", "install", *std_npm_args(prefix: buildpath/"node-gyp")
      ENV.append_path "NODE_PATH", buildpath/"node-gyp/lib/node_modules"
    end
    node_modules.glob("**/sharp").each do |sharp_dir|
      cd sharp_dir do
        ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"
        system "npm", "run", "build"
        rm_r("src/build/Release/obj.target")

        # help letta.js find source-built sharp
        sharp = Pathname.pwd.glob("src/build/Release/sharp-*.node").first
        (sharp_dir.parent/"@img"/sharp.basename(".node")).install_symlink sharp => "sharp.node"
      end
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/letta --version")

    output = shell_output("#{bin}/letta --info")
    assert_match "Pinned agents: (none)", output
  end
end