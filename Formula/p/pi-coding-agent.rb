class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.82.0.tgz"
  sha256 "a9c9d7f861a7508af5e516d493a03eac1fef36f8b56fb0d204da643950e5db08"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eb06cd28c2a0fc4a45bce9af73f33ec09676b6b5e3263019cb8b03f2ee7b8cfd"
    sha256 cellar: :any,                 arm64_sequoia: "078f3ec5528e362fb784e44c108f66e1e832d62a97ba8f354cadbb0e7f0ec275"
    sha256 cellar: :any,                 arm64_sonoma:  "7a5cf140cd49579e13d9599c0ef9a753a31e07232709d18d0d8e477109da98a2"
    sha256 cellar: :any,                 sonoma:        "f3595ae1279c64cc51788c3c79558375ef989e095eefaab0e39fa0f1ebdd6b14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d459f36c08f980a36c1de5fc58a92d64030903556c69dc224ec9a1436f771c5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fa94de8f9732bb8a34fb8e4698bcb650490cacb430eedbc380fa621f01374df"
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