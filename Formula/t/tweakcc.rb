class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-3.3.0.tgz"
  sha256 "cb6337446361186980fd9ed9dddfc7250fc82d81d96f959b7c845e3ddda8acc5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0df524ac43a044d30127064507e9e039c51b6531fce7c88f6d3444607155bcb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b4faf7c4374fb7dd277c2e227939f67a22fe11a2b16f143ffd99343c54edbd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b4faf7c4374fb7dd277c2e227939f67a22fe11a2b16f143ffd99343c54edbd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "56f7e59fdb08376b9bd1bf6faf422d0c8458a04b8af5a27dfb5b5f1b8088f3df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6243fb0a4d5502235039ed32709f5ff535e90e15ad361dbeb8cdb219b29565de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26833eceddc56b7bec28bc5d3cfc4c876d2e48a2641f4504627ef8dd8961e23d"
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

    # Replace universal binaries with their native slices
    deuniversalize_machos node_modules/"app-path/main" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tweakcc --version")

    output = shell_output("#{bin}/tweakcc --apply 2>&1", 1)
    assert_match "Applying saved customizations to Claude Code", output
  end
end