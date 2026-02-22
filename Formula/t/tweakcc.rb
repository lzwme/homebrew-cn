class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-4.0.4.tgz"
  sha256 "0a69ccf3a348cc40ded52d3be78557f4196a34e6c6ef65f4a9f37e6397a6fc26"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d1a1177881c0d1d644426984eb01aa341f3254251fb7f036026b68f1b6c6a400"
    sha256 cellar: :any,                 arm64_sequoia: "dfb4c82825bf53cc91db745f4ceaaba37acf14a8582a4a376665b0de23362458"
    sha256 cellar: :any,                 arm64_sonoma:  "dfb4c82825bf53cc91db745f4ceaaba37acf14a8582a4a376665b0de23362458"
    sha256 cellar: :any,                 sonoma:        "43d3eae7740ef0931a38dc89e113ac8354c177962cf5bf4a7d94d50551bf1730"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02f653911334e62278b7c4d9f93b39aee40b2eba578a1381ad6bafba9f1a3524"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f67bca0ff9803577a20f1f86c8d6ecde43f3b41cee23ea9f37a215967f62db2b"
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