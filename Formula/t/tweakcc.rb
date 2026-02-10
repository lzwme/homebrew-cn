class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-4.0.0.tgz"
  sha256 "0ce68d4dd3ba0c1c57ec82739cec781e8467f7b7b6537749afcdfdfbe95ce89b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ea1d4bb66fb3ea7b0831192126764becaecc3da1c89771ac477b9cfb4be38524"
    sha256 cellar: :any,                 arm64_sequoia: "954ecc19e5abe6511a69358de5bb7f0af5fe39349b94418d044640ec0c32da1e"
    sha256 cellar: :any,                 arm64_sonoma:  "954ecc19e5abe6511a69358de5bb7f0af5fe39349b94418d044640ec0c32da1e"
    sha256 cellar: :any,                 sonoma:        "32776b16ad2aedd11330b589c39c97c2f9d03f71cd988a93060d3f2bcdb91f15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27b6d9a6bf3401ed733d0dc4a094f112a57475fc9ea62fdb4a45af81e292293c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e154a56d8f7aa8641c7b83ce5f75d689001a054af67357d9e25df5bac23f441"
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