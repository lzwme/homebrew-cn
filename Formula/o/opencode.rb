class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.168.tgz"
  sha256 "56404ef8e4dcb8894487ddb2e6e40b71ead48be96d39602ba922564f9bb9ff32"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "020d65c1445485163bee3c7e7ecbe8f6613c22f37c3e9a575ed90f11b648065a"
    sha256                               arm64_sequoia: "020d65c1445485163bee3c7e7ecbe8f6613c22f37c3e9a575ed90f11b648065a"
    sha256                               arm64_sonoma:  "020d65c1445485163bee3c7e7ecbe8f6613c22f37c3e9a575ed90f11b648065a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e057e0f0431673dcb878632c9d024f2a66cb21738e34fd5a91146b1618aaa1a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "caaeb6ddc44059d6a25c068b9b33d87c25ee08d7681cbf31213a60971e8db793"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08e1fa2cdecf54c5da8e5cd3fa3404d9a710d837839303e5c1f5e6ac9ecdc907"
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