class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.84.4.tgz"
  sha256 "5bce766d19c3ceba18f3fbaad91c449c9f9d73981f9e3400ecef932006f06968"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6ca8cc0913b9cb6dfca9fb2a60aca81e225a436f4a13b7fd1ec5bde8797c2b9d"
    sha256 cellar: :any,                 arm64_sequoia: "f40616cca43baaa06bc698cb3659960259bfbc09637cd2544c065e6473f9bb48"
    sha256 cellar: :any,                 arm64_sonoma:  "43e45aa96d77fb7cff4033f669e36e40ac3cdf9f69ac110ba0419bd73c0786e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbff72f5e18968b8b5187ebf1c4d3138a789d7c4588dc58da02faa8a09119a71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9350a9515d3d72d962f5e0d2c6a0e9981235ca59c1725942e0a54af1ae111137"
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