class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.84.3.tgz"
  sha256 "d07dc417f78a14dac376a878b6556b51961f118f79771ee375333dc51356bc75"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3e25c185fab35bb14846d4bb4b8201e398d267bc5848d126bd70780746d7bd7a"
    sha256 cellar: :any,                 arm64_sequoia: "28332ffe8ebb0b7bf99e548be93c12f30b8d8d9d10ea2ef623c613989ab3a529"
    sha256 cellar: :any,                 arm64_sonoma:  "073233bd9303df4c8339b4ac532186cbaff456eea6da27a0c41632aee60da071"
    sha256 cellar: :any,                 sonoma:        "d7e196282616d7c6f9f2046a7c35c2762cabeff21e24a1cb783555acb2e389c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0297274302de0e059cb6a3d47f3f5986e9435534ddbd23804a5d9b0f28996876"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6228d11a0909178a9013e1dc513bb54094037ca2b5131e3d961a38bf7adf08dc"
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