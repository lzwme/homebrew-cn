class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.83.0.tgz"
  sha256 "7097fe4b38762dda7ec78001e7b90430c849fbaf717325bfe8109744e32255e6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a01613b02105189566c5de5e1c461289183adab91f29d179ad5e112fef546648"
    sha256 cellar: :any,                 arm64_sequoia: "c854a6ce695b7b160b0533202ca41553066dbea236ea003cd72cc6abab1d9ea9"
    sha256 cellar: :any,                 arm64_sonoma:  "a088635559b7883717996b0c7a11a70171b428257955fb2f15af4aae38b1efe4"
    sha256 cellar: :any,                 sonoma:        "2076c3a9b2bca48ec8fd6be57b95dcadfb1ac49cd4e317976ff03e25dc442130"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c2967c5b464e86df5801c99ead472d92febbbb510d827afed8ddbb4b7428d6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b557db7d1704b59136c8e31c5308b165f0938e29a9a32f5f2fa51551b5b5fce"
  end

  depends_on "node"

  on_macos do
    depends_on "rust" => :build

    resource "clipboard" do
      url "https://registry.npmjs.org/@mariozechner/clipboard/-/clipboard-0.3.9.tgz"
      sha256 "25986ebeecaffadf3d1dd5f9199869057e4b64c37d7069c7f31c231dd86b5639"
    end
  end

  def install
    system "npm", "install", *std_npm_args
    (bin/"pi").write_env_script libexec/"bin/pi", PI_SKIP_VERSION_CHECK: 1

    node_modules = libexec/"lib/node_modules/@earendil-works/pi-coding-agent/node_modules/"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    node_modules.glob("koffi/build/koffi/*").each do |dir|
      basename = dir.basename.to_s
      rm_r(dir) if basename != "#{os}_#{arch}"
    end

    node_modules.glob("@earendil-works/pi-tui/native/**/prebuilds/*").each do |dir|
      basename = dir.basename.to_s
      rm_r(dir) if basename != "#{os}-#{arch}"
    end

    return unless OS.mac?

    # Rebuild as the npm prebuilt lacks Mach-O header space to relocate install names for bottling
    resource("clipboard").stage do
      system "cargo", "build", "--lib", "--release"
      cp "target/release/libcrosscopy_clipboard.dylib",
         node_modules/"@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pi --version 2>&1")

    ENV["GEMINI_API_KEY"] = "invalid_key"
    output = shell_output("#{bin}/pi -p 'foobar' 2>&1", 1)
    assert_match "API key not valid", output
  end
end