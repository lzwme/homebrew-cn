class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.88.tgz"
  sha256 "815323da8b38915b113eb7d05e38753efb14f0e47ea71ae6d81a425bcfcf6302"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "aea64405de722191bf89343486cfb3971834c0ed2cbd63f47abde9e778b1a159"
    sha256                               arm64_sequoia: "aea64405de722191bf89343486cfb3971834c0ed2cbd63f47abde9e778b1a159"
    sha256                               arm64_sonoma:  "aea64405de722191bf89343486cfb3971834c0ed2cbd63f47abde9e778b1a159"
    sha256 cellar: :any_skip_relocation, sonoma:        "645d72a93aecd7184b3d76d1f38f1f085fe35612edfec9a2ff17f7b4abd4748c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c08c0cd83e80c75a3d4a5c678b7cebd5faf8f84da3b7782fdc8603db1bb85456"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6631ff26d70f520104459d3d526695c4dcc71d487cb9d3c371109fa7cd8bca12"
  end

  depends_on "node"

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