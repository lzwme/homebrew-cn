class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.56.2.tgz"
  sha256 "5e6a2454dacbd459becdf7c552927e6b4e4eabb8862d85771cb7b9384f633559"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a42b6d146dcdeeaa72c40e9b5cefb65572d83a98adfd3122ec2c306a326ae522"
    sha256 cellar: :any,                 arm64_sequoia: "3820b2f63691d77f7d14220e9cfaf19feffe91678aaa263a6ebc54afd8e57352"
    sha256 cellar: :any,                 arm64_sonoma:  "3820b2f63691d77f7d14220e9cfaf19feffe91678aaa263a6ebc54afd8e57352"
    sha256 cellar: :any,                 sonoma:        "abbe6545ccbc60b18004a00f4ec93a2e184370d450554e8e7b8ab1f36d031b29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c4578caee7ac8e5c785eff1c86f7c19ef7905e855fcfe8a05c532294536a001"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fc74fddf17317766965b77831a6d1cad2db8e3aafc09c09877c4347eecb1a4e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@mariozechner/pi-coding-agent/node_modules/"
    deuniversalize_machos node_modules/"@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"

    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    node_modules.glob("koffi/build/koffi/*").each do |dir|
      basename = dir.basename.to_s
      rm_r(dir) if basename != "#{os}_#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pi --version")

    ENV["GEMINI_API_KEY"] = "invalid_key"
    output = shell_output("#{bin}/pi -p 'foobar' 2>&1", 1)
    assert_match "API key not valid", output
  end
end