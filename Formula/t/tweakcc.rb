class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-3.2.0.tgz"
  sha256 "8f807276fa2d3ce7d029b8ff93ca63e8b8ea23426233ee20fd3483e15b787e21"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c5a72d03d57d7a47040a1e0fa47468d5f0c44e10d5844c65694df1102d5d208"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59c1c63516905adada73898568586e972ceb5c452e0d8874f4656e9945d3e368"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59c1c63516905adada73898568586e972ceb5c452e0d8874f4656e9945d3e368"
    sha256 cellar: :any_skip_relocation, sonoma:        "355a754e7f63d462e483e0ad0cd04145f652f79af5d5a44ad0285f5153cc2679"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b0e57c75218c5f35d99553ad350d68a1850374e37b70cc43296dd5697ba208f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e74e9dbd813137c00368d39d3d36fdfaf959b7dd211603b232887059e430cb6"
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