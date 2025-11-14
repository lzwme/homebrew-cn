class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-3.0.2.tgz"
  sha256 "7b300ea390eebb5933e2b847baf83654f8ffa8cfa1c8edc16b5be15316537b20"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "047fa67cc1c1722bcefd822ae3a1f5d4d0e5cbb7caba9edb98a90370cf99f1dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "047fa67cc1c1722bcefd822ae3a1f5d4d0e5cbb7caba9edb98a90370cf99f1dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "047fa67cc1c1722bcefd822ae3a1f5d4d0e5cbb7caba9edb98a90370cf99f1dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "19a8375ca4697157d6a4f4ee56e55becc02eddd19868479e5c333327ce89bb33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8e7422c9add8e5eb6bee803bc57d9305b5330257e4873e116c27353e9ec7c0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dba297b7f3acb8773bf4367292e51163f18d5c80872bbe271368cff068852a7c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove binaries for other architectures and musl
    os = OS.linux? ? "linux" : "darwin"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    prebuilds = libexec/"lib/node_modules/tweakcc/node_modules/node-lief/prebuilds"
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