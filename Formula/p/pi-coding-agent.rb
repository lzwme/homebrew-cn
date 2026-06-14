class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.79.2.tgz"
  sha256 "8c334b39212bd5070b31a8dfa9f8b2c2f8a1bdb4251747d8d45cb428939bf602"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "55f891c00850e88b56248bc60399fbfc7c36779fa6a12ae43568285880f348e9"
    sha256 cellar: :any,                 arm64_sequoia: "f4027128c900eefb94a426a6c186bcca81bf7afc10adf18b53bfd22dafc11023"
    sha256 cellar: :any,                 arm64_sonoma:  "f4027128c900eefb94a426a6c186bcca81bf7afc10adf18b53bfd22dafc11023"
    sha256 cellar: :any,                 sonoma:        "4c0823c57a94f359a5c386d65e2597528e86963fdcae1af93e4366c5b81b8c78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3901cf83e6ca3ca5edeba2b827e1809c1ef8a9d7df0ecf7024f7ab78221d6e91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4898ea021ea615c0c12f201419b7e8712578308eb338f1dd1eff71fa9672dbff"
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