class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.79.9.tgz"
  sha256 "6ef6adfb8c3b6b0df7e54a7eae83a00697e816b26acccae95e8b1ea9eaad85ff"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "73c4f8bda7c8129f37cd4dcf4fe4bd3d050ea4554fa3d0333dd9d93e9a86195f"
    sha256 cellar: :any,                 arm64_sequoia: "395285c44c9c3136d10e18a96a698ac071d0d43b2cbb016cda3f1b6fcc680c17"
    sha256 cellar: :any,                 arm64_sonoma:  "395285c44c9c3136d10e18a96a698ac071d0d43b2cbb016cda3f1b6fcc680c17"
    sha256 cellar: :any,                 sonoma:        "649589623d2feb75b0007ae29dabaa8c9229694ca086ab5da4a12467ec67565e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "601c926b0bae6efc82da1090af1d31666c11f7007bbf703c1503f5136efa3f92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f29856bde141820b459c8bcafae515ad616927628b5d131d98cbbbb786d0b89"
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