class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.70.0.tgz"
  sha256 "8b76e853b970b6e73aed5a6122ae0bd1265283f57ebf92a03a536019d9a30177"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d14a2ef44a80186c849328ab423b8a3d8fbb188b2ee7e97f87acbe6fb420fa0c"
    sha256 cellar: :any,                 arm64_sequoia: "72570abbe952705fd45dbc3510cc76eff62c36a31d7f5c84d604d79be4cbaacf"
    sha256 cellar: :any,                 arm64_sonoma:  "72570abbe952705fd45dbc3510cc76eff62c36a31d7f5c84d604d79be4cbaacf"
    sha256 cellar: :any,                 sonoma:        "503c5c5c29b517a5ba9b60be8eea3e0beff341637fbd6ff2b430e302ff29a4aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6263b0600dae7c23a7ead68d0602ee3cdc5da80603c3d96be664d477b2511905"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b5dbb91e6d6908d8222aca54079d91ecdf2df16421cf1ea63df4ac34dda237d"
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
    assert_match version.to_s, shell_output("#{bin}/pi --version 2>&1")

    ENV["GEMINI_API_KEY"] = "invalid_key"
    output = shell_output("#{bin}/pi -p 'foobar' 2>&1", 1)
    assert_match "API key not valid", output
  end
end