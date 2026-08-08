class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.84.0.tgz"
  sha256 "cecaa288d19c392987d98c4eaa853ebbe520b46511fa4dd6d863ce8704c61298"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7c37aa3535ba1bdad879abc17856d8c4355e967fd43965cf1ab98239ba479d35"
    sha256 cellar: :any,                 arm64_sequoia: "b626082d0806f10545907c04c69e037c52bf82b73220765a3843fe10c3387956"
    sha256 cellar: :any,                 arm64_sonoma:  "48bd245f4442156b170a3c46691f9489780f6c0324cf6115675248b8fe320c32"
    sha256 cellar: :any,                 sonoma:        "e4ad95e1eb12a9de479a45aa82170215d6a8d1b113ffd23b2bd3e5f4a1115c06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "084a06cd01c12c605787315579543b0bb1e53b1a2427ce56b2f7cbfc9898f658"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a3a888223436bfb9cb3999386d13870833c8d231def29f87be83155993fb6ee"
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