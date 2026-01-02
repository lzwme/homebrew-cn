class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-3.2.3.tgz"
  sha256 "b8b126c1c8af41e30e0889a43a1e035e87c52a0a4f74da060ebeb116e418c47a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "969c188eb5fc2fdd0147ac8a698bcaab621a07b52ebffceab18f61223f0f6e16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "419899e7b89399e04b76321894329a0ab9a3e476c3a375d38e907bac45527f1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "419899e7b89399e04b76321894329a0ab9a3e476c3a375d38e907bac45527f1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "646810be6137889d0a388ded13d441de3ec836387f742f7d2b508eb3f2b54de0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92fa5c789e4332b9ff91972249a377a2eb8c7cab159da6063863cd6273ec559a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0589179ac94f43c5333095a3f6c6875cc64446cb012c153ee48786f71f8d0bef"
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