class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-4.2.0.tgz"
  sha256 "3a1a09165a0145ca6b37199a883893dfeb8266376beb0394fd0971622da18b55"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "42eb7b7c8ee37ac33c90af9fa965004a1797d533f19e0ecb425493b1eac09b2a"
    sha256 cellar: :any,                 arm64_sequoia: "963627dd9f4fd2f5f96d718b0837d78696c18871cd1d675f3a2448316558427d"
    sha256 cellar: :any,                 arm64_sonoma:  "963627dd9f4fd2f5f96d718b0837d78696c18871cd1d675f3a2448316558427d"
    sha256 cellar: :any,                 sonoma:        "5d711ff4d32d6d4204fd21079b0688a1569aa8652720a1c4c86321950997799e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85d22620b27ab4174e15b628e29a2451b27e8b47247d3987a577dda29f7b3a23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f47a89af68dc19eaf404c7a444b6b82b7aaf8fd4f97b50588ca1eba11a3e96c6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove binaries for other architectures and musl
    os = OS.linux? ? "linux" : "darwin"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    node_modules = libexec/"lib/node_modules/tweakcc/node_modules"
    prebuilds = node_modules/"node-lief/prebuilds"
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