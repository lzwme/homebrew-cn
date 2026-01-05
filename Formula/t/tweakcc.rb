class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-3.2.4.tgz"
  sha256 "9af752d01d5ea5d966548d8ccd7e9d6c1ebdea3538e40d293702298e75d8456e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8cf5d6e71c54d63e51d00e826e7829a871a1a9fad7e01c8c0e9c358d19e48205"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a3d5a81aceba75905a93ed6606f1f32f73ac8352f970b2d2984e2ac07272fbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a3d5a81aceba75905a93ed6606f1f32f73ac8352f970b2d2984e2ac07272fbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9daacd6861b4f19f94d849dfadb8b51481c7b0a5af3f2c7087b89f58ace00bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41e11b7d3ba41482dd58fe554504cbadb42f1261fce9f3da9b9c00f48d7c10f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b507eeac097baaa73dc7879a4527e54ecf4841263ce483026efdd022c55ef47"
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