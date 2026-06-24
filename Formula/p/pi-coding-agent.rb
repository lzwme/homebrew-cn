class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.79.10.tgz"
  sha256 "315cf1b21c76d4d7290f00a2d6e20e15ed9a3dc8ffc47f13dab25c0f0b1184b1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1634a873958aaa58601375a694ec8d875770ed7fc00a7e2b1c5923130aa70a5f"
    sha256 cellar: :any,                 arm64_sequoia: "6fa5e7ca54139252ea0731fbe58e64679f98e225cfb883d0229478602463256f"
    sha256 cellar: :any,                 arm64_sonoma:  "6fa5e7ca54139252ea0731fbe58e64679f98e225cfb883d0229478602463256f"
    sha256 cellar: :any,                 sonoma:        "db84c7562d4b4656120820b63bb92475b41bda4bd8619823952b41991dd0ed26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee4d8ec0630e4e96fe516722a5616dd281172da6862c1b3bd5952e768702118f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de36e36be15d03278c9652dd7454e51ec131012354f69815d33cbbef7284cedb"
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