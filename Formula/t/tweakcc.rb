class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-4.0.10.tgz"
  sha256 "873cf2daa989e254b9d66c9f5808fe62de563dcb3c6d6ebf14b97fbdd9b3ff4d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dbeb9f0ac2391720e07cf5f1f1ea724ffe84b61c3ed43f10127d65724104c69e"
    sha256 cellar: :any,                 arm64_sequoia: "a62110c8380661a9e2a42eaf73833c916f61ff4f66bd45a6a1f9c608707ce0ae"
    sha256 cellar: :any,                 arm64_sonoma:  "a62110c8380661a9e2a42eaf73833c916f61ff4f66bd45a6a1f9c608707ce0ae"
    sha256 cellar: :any,                 sonoma:        "251c0532bbf8d27a05c3aef65e35d25981d9eac7a58673cb6547305a126b3cbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff1d895751f68240d17a242f7d760c09a602dcc6d2e68480a43907c47b12ce85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "231377e19ff853251c18d82918a3ed32eafac5b5645778e839de97f7e7de6e55"
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