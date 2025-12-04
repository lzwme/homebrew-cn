class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.129.tgz"
  sha256 "06344dcda4201ce6e45130d4ced3fd2c48ba7342eef98edcca48ccc9510b1c18"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "6827bdfe198dbca45b6223008ba2a6f83cd8ddc690d7a3927c3a66e5dd74155b"
    sha256                               arm64_sequoia: "6827bdfe198dbca45b6223008ba2a6f83cd8ddc690d7a3927c3a66e5dd74155b"
    sha256                               arm64_sonoma:  "6827bdfe198dbca45b6223008ba2a6f83cd8ddc690d7a3927c3a66e5dd74155b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f303ccfcbc488ec10f69aa30575acab0d4a7ffcb72a22f0209511d2f31bcbf1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8dfaf239289e0c4fe669f33f3d63292f54bfa3fb1833f2f02b3c7b43abf86ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "847ca529e824dac1d1ed061d3ff86fc94d1cf10fa20334d9938f4cb620f0fe80"
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