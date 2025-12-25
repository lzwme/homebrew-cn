class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.198.tgz"
  sha256 "c14d51f36356dd54d440105108e71db6e868955a7e949c95de191ed575a6d14f"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "55a44f1c0c94c93d35189adf7c9d7c25f6cf1e65edd8e2ba5e55e47452b188e6"
    sha256                               arm64_sequoia: "55a44f1c0c94c93d35189adf7c9d7c25f6cf1e65edd8e2ba5e55e47452b188e6"
    sha256                               arm64_sonoma:  "55a44f1c0c94c93d35189adf7c9d7c25f6cf1e65edd8e2ba5e55e47452b188e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd341494e4ad2f7e751587a478b567059229732daad4d6050965f86320692e9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52d6d54fb1851f4862be2b20672c9266febe3422c7f13c380c74a126cea769b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1921450423af56625a502ee6983940bdbc71d49b725044f45f2c231ee277c939"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove binaries for other architectures, `-musl`, `-baseline`, and `-baseline-musl`
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    (libexec/"lib/node_modules/opencode-ai/node_modules").children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "opencode-#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end