class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-4.0.1.tgz"
  sha256 "16a402ce7f45c1283e703226e26ce87e6e2b44d8598db0a6779037e415047535"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c701bae569f6295c19dc5065dcbb3e0d83ae2dd72a4749b304f923c832cdb21f"
    sha256 cellar: :any,                 arm64_sequoia: "48cde2f4f3f71cc266851ed3858f69d48e2582c85a9c69ad42581153e69bf938"
    sha256 cellar: :any,                 arm64_sonoma:  "48cde2f4f3f71cc266851ed3858f69d48e2582c85a9c69ad42581153e69bf938"
    sha256 cellar: :any,                 sonoma:        "f24bdd6b78cd84737e76028a8782449de1a1be02793c4a339fb2a77e386e4a53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a431e67c8441c5cf747991dfa1f1cc4e3bfe2701b3a836b1700dfcac4efa1e92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d7ebbf493a45c6823d397c609dac85c4975b042f3c9b53d8ccecff6d638f4ba"
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