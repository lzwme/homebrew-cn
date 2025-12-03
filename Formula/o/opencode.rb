class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.128.tgz"
  sha256 "70d3faf436a83b9521ac20d44c9138fabccd480540a0ee8892d7f5f4e7b6d266"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "6247f0232f31f9c9c6948037fcc751b157187d17d62faabe5f9d57c8a9e5cdc3"
    sha256                               arm64_sequoia: "6247f0232f31f9c9c6948037fcc751b157187d17d62faabe5f9d57c8a9e5cdc3"
    sha256                               arm64_sonoma:  "6247f0232f31f9c9c6948037fcc751b157187d17d62faabe5f9d57c8a9e5cdc3"
    sha256 cellar: :any_skip_relocation, sonoma:        "4170d3c68e780af0f6068cfd37e67b513191712fafbe5d565f0add8173ae2245"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fd9e5c17d582fed0d9a348d3790af1e567630e79ca2d144ac68c07fec63ef12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b3668d098c60395cc1e1bc8d5e83e3b5de35cc2bd8dc05200bcf08ef70c7cc8"
  end

  depends_on "node"

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