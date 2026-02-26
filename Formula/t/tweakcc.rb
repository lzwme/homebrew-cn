class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-4.0.9.tgz"
  sha256 "d1d502215f338a03cc751e01cc8c15fde61fda876d18b88f2efcc839993f4028"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "78981c00ced5e195da6c14da5c40aa173cd110f9484847b7c6f7efae2d2564ed"
    sha256 cellar: :any,                 arm64_sequoia: "21b5963162b7d378ed95ac6a8e560cb6340ffe8b3b06913305ef50744d8e1242"
    sha256 cellar: :any,                 arm64_sonoma:  "21b5963162b7d378ed95ac6a8e560cb6340ffe8b3b06913305ef50744d8e1242"
    sha256 cellar: :any,                 sonoma:        "76c9b634409a985de2d0cb53be997527ffeb10b68a59a7a1f9c772f4f050e408"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb89729e8a1d2d07efab713fd3187d758372636a96ac530433af7dc4c5d553ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e464a58c1f2580fb61da298abf8eb842eae87177a5b328691a5d5195e5ba13f3"
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