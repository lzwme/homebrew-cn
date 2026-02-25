class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-4.0.8.tgz"
  sha256 "baf19707da2b973cdaf3778bb04b4da47dc12cf0651b4b719ae876ee445a0674"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2f3e93ae15be8ea8ccda6de126a45d64da1e1bd1b24452a8f0055f871dab1dbf"
    sha256 cellar: :any,                 arm64_sequoia: "fe0a616cf61dcdb3104034aa357f99c456cbda5e48533452070b8ac7de26bfd4"
    sha256 cellar: :any,                 arm64_sonoma:  "fe0a616cf61dcdb3104034aa357f99c456cbda5e48533452070b8ac7de26bfd4"
    sha256 cellar: :any,                 sonoma:        "fcebbfbfcaa48add2e42fd02531a4ed990c772ea246263e7631d8e837282af0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62387cbfd490c47e7c8b3478288363e3083cb6a4440c8d1378bc499f715d0c12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce90c981afe426a0f2451a1317e5b3f6614e1493012928dc5692b9be22cfcd10"
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