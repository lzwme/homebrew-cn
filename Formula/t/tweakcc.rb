class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-3.2.2.tgz"
  sha256 "4a07c4054b044e72561ffd7017b9f9c6e37e87d73c2444f5da31f0916afb73ad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da0c6bcc9be2c06c1a19441a0898e8654e2d2e41c0c45aeba2595b3a8f710208"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7e52f82fa51a58c77cdf61d60e5d44111f07b63961d3c936e802d2357578d62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7e52f82fa51a58c77cdf61d60e5d44111f07b63961d3c936e802d2357578d62"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b512376e6f991881ab9f435240e53f6f963db1fa54b211fd360d30efec02899"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0dad2a5c59af92d1a8c48f3b966847d9264ca63c5705020d8640e9516ac71bd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee7268b90403d96e09f82bf5caba19f6bb1447af2cad093abfcaee99d39fbd8c"
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