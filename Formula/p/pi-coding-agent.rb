class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-1.2.0.tgz"
  sha256 "1dfed308f46a69aec06bf9dc20700ddc6fe2370b1898f01334b7898397541e66"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "53791f5330be59dd50fe38ab83292bf202dabc589c1c3d582b2bc7ed215de9dc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "53791f5330be59dd50fe38ab83292bf202dabc589c1c3d582b2bc7ed215de9dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "53791f5330be59dd50fe38ab83292bf202dabc589c1c3d582b2bc7ed215de9dc"
    sha256 cellar: :any,                 arm64_linux:       "0232a59510a607c3f149e55c13959502b982f208509bdd4a7c85eff8299d14b8"
    sha256 cellar: :any,                 x86_64_linux:      "17ad72baf6384d2df5b7cd09bd4ec4beef0aa9a05c9d15703f0ec08a6967af3e"
  end

  depends_on "node"

  on_linux do
    depends_on "libxcb"
  end

  def install
    system "npm", "install", *std_npm_args
    (bin/"pi").write_env_script libexec/"bin/pi", PI_SKIP_VERSION_CHECK: "1"

    node_modules = libexec/"lib/node_modules/@earendil-works/pi-coding-agent/node_modules/"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    node_modules.glob("@earendil-works/pi-tui/native/**/prebuilds/*").each do |dir|
      basename = dir.basename.to_s
      rm_r(dir) if basename != "#{os}-#{arch}"
    end

    # Rebuild the X11 clipboard helper against our `libxcb`
    system "bash", node_modules/"@earendil-works/pi-tui/native/linux/build.sh" if OS.linux?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pi --version 2>&1")

    ENV["GEMINI_API_KEY"] = "invalid_key"
    output = shell_output("#{bin}/pi -p 'foobar' 2>&1", 1)
    assert_match "API key not valid", output
  end
end