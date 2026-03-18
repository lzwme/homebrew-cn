class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.59.0.tgz"
  sha256 "f9f7a129530f8ef9a59588685462f457a8a756868c83a7c9aeca3c07a185f1d7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a2e0f7797db19a474662b9e126ed5acf9d3d1f9091d7bec6bbc5930e7b31c147"
    sha256 cellar: :any,                 arm64_sequoia: "8b5709cac654f33669d8abb61764f13a1b4be171bd20bc4ccc1132e3f4e5b27f"
    sha256 cellar: :any,                 arm64_sonoma:  "8b5709cac654f33669d8abb61764f13a1b4be171bd20bc4ccc1132e3f4e5b27f"
    sha256 cellar: :any,                 sonoma:        "60fa5a8721fc6bb244c97725fea80e7a66a24088c5041438c06c3684fcfb15c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "169e6c86ee7b4073adfa7f08a4c805c477e53891e16b43a14d694f6068cbfad9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8107f3a7b5cdf5a73466f677cf7231a07c88c874557e035830a2611caac0f643"
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