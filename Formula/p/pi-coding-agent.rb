class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.85.0.tgz"
  sha256 "a0895f70a9efd9dde2a69b9cee04cb3b7c5aab68f5d47aad92b63f27a4ca13c8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6029cf2b01e3960cb5a75efc837070012ac50753c68bd93e53d8b4cabaf32df3"
    sha256 cellar: :any,                 arm64_sequoia: "fa79cafe30546c51aa3ad4b0d7808e9ec5f30d1b95244f7ba5cc8f8ee32604ec"
    sha256 cellar: :any,                 arm64_sonoma:  "f458d4a01502b097882765dcbf7421564b46de6f9915a3a8ac48cec07ebb3e7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "926f5a1360239b577269a416205f1048f66af5d9940da47a5cc48bd636b206a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00f80366ae88a7455671fbe16ce5d75738431aac596ae85007fd76e79a6e48d6"
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