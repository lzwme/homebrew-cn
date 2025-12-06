class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-3.1.6.tgz"
  sha256 "f52019446f3d2b885548b6860df83e52644c74219565e410ee360550891ba7bc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a89739b929578247b0a4abdd8ae34ac1ba58b0760a9446cfe589f5dd37aa0ad7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a89739b929578247b0a4abdd8ae34ac1ba58b0760a9446cfe589f5dd37aa0ad7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a89739b929578247b0a4abdd8ae34ac1ba58b0760a9446cfe589f5dd37aa0ad7"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f40f09f03485c09f5ee1c113ead81b46ba414fedb5bd292a1bdc64a59913800"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccd621df8bb04e43059f32880ab3a4cef9471fdf9aff3d0259b0e12e4062ec27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7937aebef43db9441e37e53a72b0f72a46195fe31c448898af21c9cc04a5e4ac"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove binaries for other architectures and musl
    os = OS.linux? ? "linux" : "darwin"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    prebuilds = libexec/"lib/node_modules/tweakcc/node_modules/node-lief/prebuilds"
    prebuilds.children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "#{os}-#{arch}"
    end
    rm prebuilds/"#{os}-#{arch}/node-lief.musl.node" if OS.linux?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tweakcc --version")

    output = shell_output("#{bin}/tweakcc --apply 2>&1", 1)
    assert_match "Applying saved customizations to Claude Code", output
  end
end