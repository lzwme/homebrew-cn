class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.79.7.tgz"
  sha256 "2cda1beb3c80d451ce5db5dab8276f222d9d1c3c34b2dc46f2afde71c71d4841"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8383db1285a0ad65b4ae7c5cd1bfebc4ea9e78da00cb08d22d6a5054f1e5192a"
    sha256 cellar: :any,                 arm64_sequoia: "191879fdf90704e9396a192767740f562693e8c7f10f3ca2217e96f9624b8371"
    sha256 cellar: :any,                 arm64_sonoma:  "191879fdf90704e9396a192767740f562693e8c7f10f3ca2217e96f9624b8371"
    sha256 cellar: :any,                 sonoma:        "c0a6e8e4d50fabf8afc973616bd6ea6edf985e2ea620f2ade0fb6a22aad1f73b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12a31be32b21384a46feda1c79e536c0d30b29bb39b1f0c6095767a8c5fa0d5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f374c9bea133927ddc44b4ad92662d3c1d9912803a34592b0371d97475772a5f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@earendil-works/pi-coding-agent/node_modules/"
    deuniversalize_machos node_modules/"@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"

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
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pi --version 2>&1")

    ENV["GEMINI_API_KEY"] = "invalid_key"
    output = shell_output("#{bin}/pi -p 'foobar' 2>&1", 1)
    assert_match "API key not valid", output
  end
end