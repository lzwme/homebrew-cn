class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.171.tgz"
  sha256 "564100cc917542d1adaae4b9e26b0f3330dd3178ff355f29c6ac833353121498"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "cc88b407e1f92c1011e82446cc71aa8f4a8f7345ac2d9873fd8218ddceb006cb"
    sha256                               arm64_sequoia: "cc88b407e1f92c1011e82446cc71aa8f4a8f7345ac2d9873fd8218ddceb006cb"
    sha256                               arm64_sonoma:  "cc88b407e1f92c1011e82446cc71aa8f4a8f7345ac2d9873fd8218ddceb006cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1d6be38a1263d767c7fac8b91966b7be48ad6c53f92731a829f6a8a47ea27d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebf40e1bcfe1c9a6b13e972c0b3855547580ce4ca6041bfd5edb27615e4beba8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "007b9ec64dadd16a14ad498c4fa505d8a9b16d4767be20566e1fa559f8f967a7"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove binaries for other architectures, `-musl`, `-baseline`, and `-baseline-musl`
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    (libexec/"lib/node_modules/opencode-ai/node_modules").children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "opencode-#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end