class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.82.1.tgz"
  sha256 "8343ab95cbab5766f2f5d48844df8db13e772ead2e2976166cbb820a29dacb7d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a562bfef68dacaba541000c0c8fe3139c3b65b02752631fbfe008c69e68a3bcb"
    sha256 cellar: :any,                 arm64_sequoia: "1a5dfe9e0e952b7bc189a913cc39c163616196f2288baf25b830dd3ca8577cd4"
    sha256 cellar: :any,                 arm64_sonoma:  "21585c2cecdc7b12fd323a69276f81c1abb82fb63e385d55c7f7ada75c483a0a"
    sha256 cellar: :any,                 sonoma:        "bd7f4d722c5165e7b4eb4f7af7c0eb9e6819384eae96be6c3e594641fae873db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0876357f4af14bd8bb45255eafc87954d0f0947f718227324487f91512a6f1c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9e9eaa652f12d3208a1eb01e5a9acd37a28323161bad878af212db633a10f78"
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