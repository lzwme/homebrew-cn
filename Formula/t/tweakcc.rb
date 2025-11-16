class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-3.1.0.tgz"
  sha256 "f0cb755a411ab0b23d85cd341239108fcf135ec01d0139c13573a640b90867dd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67fb3abf7b2883a5be51d54bf78f680292e99009b326049265de8fad8a96dbe4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67fb3abf7b2883a5be51d54bf78f680292e99009b326049265de8fad8a96dbe4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67fb3abf7b2883a5be51d54bf78f680292e99009b326049265de8fad8a96dbe4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b88566ec2fe81636bf3ba7a2b56293f833c4f3789da006b8000fc050410a9a7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e25184a2a88e3492dbb7d5096d79864199ebc50b743a1494028d340d21dfa04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45f074d32bdbc353b849fdfcd155b7de7a43f6afc44529633c621f31c8d0f7d8"
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