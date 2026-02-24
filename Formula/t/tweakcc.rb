class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-4.0.7.tgz"
  sha256 "88986f4b9718cd6c53d8dd931ece33b6cabd56bb8a7a8bbc4c31120afb0317d9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2f0b3a8149b12e377faaee710bccd4ebfe2dde91aff063b8b19bc3494907ce80"
    sha256 cellar: :any,                 arm64_sequoia: "dcdeaa3a3082eaa9d5d33ddc97b042fc30fcac2a97f9af6afd9366a5772f8ffb"
    sha256 cellar: :any,                 arm64_sonoma:  "dcdeaa3a3082eaa9d5d33ddc97b042fc30fcac2a97f9af6afd9366a5772f8ffb"
    sha256 cellar: :any,                 sonoma:        "273f1c85794bc0457fe44dcdf7c930bdb7c531e70ab72dd3842251cf7598bacc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b666ad474988bddc419218647d4735292b37e644e30b9ad2ca2d608875ccff8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b4807f8759e39fc1cbb672f5a314e88711d5a4b2949aadc9df80f899dd16bec"
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