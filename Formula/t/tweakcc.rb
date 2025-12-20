class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-3.2.1.tgz"
  sha256 "6489441ada91a6db15e4b6219c0879a2e85028e845d3645f8d09e162eec4b23c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b297b053c6f880dd36e1421a1749d615c4224dc80dfbdc38ec68ed806c429f9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dcb8303983691ac1b58946afe3cc89cde90d34a776a736e40461455a2c58ba9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6dcb8303983691ac1b58946afe3cc89cde90d34a776a736e40461455a2c58ba9"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b4d1a3d4b02270ef2f324b0420dfa4184d1f266a1f66d2a47b18e7283f5e0c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdae1f69754769745794ea29afd3b74e5cd98817bb34beb35a56fbc4ba927793"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91a0e8429f79b0c1ed7f07d1fed0ff6ad62ebc8048ddeaf181c7ee571c9a7b30"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

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

    # Replace universal binaries with their native slices
    deuniversalize_machos node_modules/"app-path/main" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tweakcc --version")

    output = shell_output("#{bin}/tweakcc --apply 2>&1", 1)
    assert_match "Applying saved customizations to Claude Code", output
  end
end