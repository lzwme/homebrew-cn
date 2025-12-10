class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.138.tgz"
  sha256 "8bc11b8988dee5e76bf915d304b17cc032710b079f057c02581930383ff5884c"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "ed3a6754f8ee3546a0039ddc15b38b5374f058ed32b0330fbe8bac6a1e5fd4eb"
    sha256                               arm64_sequoia: "ed3a6754f8ee3546a0039ddc15b38b5374f058ed32b0330fbe8bac6a1e5fd4eb"
    sha256                               arm64_sonoma:  "ed3a6754f8ee3546a0039ddc15b38b5374f058ed32b0330fbe8bac6a1e5fd4eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "71df1ef5bc8fadba9e58e818cc4fc486a75c7bafc62586c8df42fafbbab1bde9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4629a7dbbb0d44b0b0b45a9457d8f169a66540174ebc938212ae63f1853fb40f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "878ec6928385193830e4bd98c45e8c261c302958a716b3c02e92fcab5359f3e3"
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