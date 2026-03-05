class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.56.0.tgz"
  sha256 "20ab20a0f11a7a819a60c33582147750f76c8422ec2d5ba52f04e63f471b7572"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4a3e5f11d669e6da1733958c68effc213d9c2585902dc7661b5831089171f451"
    sha256 cellar: :any,                 arm64_sequoia: "b8f2ab2e9669322f5d67520d4c387fe79895559c736a7485a59e0e057f4447c2"
    sha256 cellar: :any,                 arm64_sonoma:  "b8f2ab2e9669322f5d67520d4c387fe79895559c736a7485a59e0e057f4447c2"
    sha256 cellar: :any,                 sonoma:        "d52dd6828f28367aa2a4c43b1d040d21ea4c3babd05d1e268c738d5f84a6c42d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c482c9419ab4440479a9281f6f4494d1bfbc4b496e48146406a7b55e54165b9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7ea3a1ff88ff289e9485ab34a50120b00c9098de2ea40584f0de6883b96868c"
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