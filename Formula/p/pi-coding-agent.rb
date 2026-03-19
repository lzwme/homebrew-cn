class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.60.0.tgz"
  sha256 "6dc5351d11e301928d77be0a56a4f459ca4e7578fa34c8cec4b7fba781601861"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "02132a2807aa635de813dbff22c96e607038f416899c0b4fe5de8d466fca0bcc"
    sha256 cellar: :any,                 arm64_sequoia: "f68b7926a07a5c7bb9d249d4b5cf7d47c934346aa149cfae58432cb3475b1c1b"
    sha256 cellar: :any,                 arm64_sonoma:  "f68b7926a07a5c7bb9d249d4b5cf7d47c934346aa149cfae58432cb3475b1c1b"
    sha256 cellar: :any,                 sonoma:        "ee86f4b7486766fe17e22b72088f3a22020e2367e94f1413ba0c4d9a527beb72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "910337a3817b99323d14aa01eddb7d80edabb118d7dc782a7f071669feae531b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d27d8410d2d76a3757f32e840e19f90864293265bbd05a679eac5a58d8530e0d"
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