class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.77.tgz"
  sha256 "33f8c386cbddc6c6645853589864901290029fd25806b7d26300ceec03fd7bb2"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "a8d7cfaa395e4e991f9cbf35b6da23f02da6d3cb05515f4d220566c7d5240a62"
    sha256                               arm64_sequoia: "a8d7cfaa395e4e991f9cbf35b6da23f02da6d3cb05515f4d220566c7d5240a62"
    sha256                               arm64_sonoma:  "a8d7cfaa395e4e991f9cbf35b6da23f02da6d3cb05515f4d220566c7d5240a62"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bd0103d2abc33e1e1bacb8ef8fdf6e0c6a75ef3cfc14fa48ac56eccd9888527"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfc3ea043c5a5a1ccd9f1afd77c7b89548f54881e238ec8b7142faa9a2a34c08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "399452b25f9ce7d6ca2d8d01205acf8afde9490fef1d280cabaed156b791eb4e"
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