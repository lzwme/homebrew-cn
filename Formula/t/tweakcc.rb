class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-4.3.1.tgz"
  sha256 "adbafd6e2f47d275c0731118f813932810e8e60641a196f41ed11ebe58fb7a37"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bc2f9ca99c6f1ce10bf9d55f13f6c76fa8b23fbf3153fd98430e7f23d6ad826d"
    sha256 cellar: :any,                 arm64_sequoia: "1cea0a3182b48da19e3314fac7f7ff172aec8c4c688360279afae46e66940ac9"
    sha256 cellar: :any,                 arm64_sonoma:  "1cea0a3182b48da19e3314fac7f7ff172aec8c4c688360279afae46e66940ac9"
    sha256 cellar: :any,                 sonoma:        "c2896660fba88e22193f385f2640c86467b75e60f9316be60ed32bb41de332f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b104cb307c3455f5ca8817aaacd3c30e92f7b62317cf3bc8b16d5fcbd6a0901d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61f8f25e47fa8b141717fd7e58f4648594d280079f6b29950cb0c8b081f8c7c8"
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