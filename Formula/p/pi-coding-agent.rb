class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.84.1.tgz"
  sha256 "a69a18596017e91955fd0fd677be69fab5b6ea01d5b06207bcee34ee1522bc20"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "92cac0ed5a79042f7d130c8c40b4818ad19acd16b2a8056e48f01f0b697f1d34"
    sha256 cellar: :any,                 arm64_sequoia: "b0fdce193dd7f9892998476246666319ab577d56491d19599d6b20da33c5417c"
    sha256 cellar: :any,                 arm64_sonoma:  "0c0043c0e6fbddf35925069f8cb3a0c7f1666d8808cae65aadc5007da21b8eb7"
    sha256 cellar: :any,                 sonoma:        "f4dd9bce0fee655d8f26c08bfe4035c4bb9efac2a7b6f91f165ced07e2585e99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "917aa9d2bf07c3798b52a06f46de98c28062fac93a54ded12951af03251a8d4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4060d110e1ba5eaf2bda6b8baefbfc794de1d56191aa861acf9760d74792285"
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