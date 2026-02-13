class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-4.0.2.tgz"
  sha256 "410aaac0ccf8a086167e7f20341ce22bdd347212c2e9c98d8819273ba84cb7df"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "caca37f474e06494ae85045e7b2e46be3e4c7d372813dd6ba2027f8307dca28c"
    sha256 cellar: :any,                 arm64_sequoia: "2a72e2f174d1e9b2cba68b899b8d05978caf6953be86267f4b3961c25e0e817a"
    sha256 cellar: :any,                 arm64_sonoma:  "2a72e2f174d1e9b2cba68b899b8d05978caf6953be86267f4b3961c25e0e817a"
    sha256 cellar: :any,                 sonoma:        "930c0f7646df6d06a53afbc43f6f1eece6998befc629b3c40bd20f77e2bc8f04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39b85c54f366db6b9f7476f7c97d5745f8d79938608352231063ef268aad194e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5427da37a487ced3f4c103776c43d773559fb1f8db47f8dd9b26ce28e0617db2"
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