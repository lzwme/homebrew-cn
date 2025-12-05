class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.133.tgz"
  sha256 "188ee074a9b3d575199e3a3c882d512fd0b7f9385ae1c38a065c93922a6b977f"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "8d977b709f51369e0b15701d5916e5a0a3ccaf6987353872e9c26c4757646de0"
    sha256                               arm64_sequoia: "8d977b709f51369e0b15701d5916e5a0a3ccaf6987353872e9c26c4757646de0"
    sha256                               arm64_sonoma:  "8d977b709f51369e0b15701d5916e5a0a3ccaf6987353872e9c26c4757646de0"
    sha256 cellar: :any_skip_relocation, sonoma:        "1667ebcec9497e4d6f2dde4fe97c3c0b872f331216608172b4d56c93802b5304"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f631e82cf9c241bbfee281b8a11f249c27a1c6ae22982833c4a9796fce04b595"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eaf3db2e0eaf2eb61058b08ec93bc2a994f9794acc914b481052ebbf7ba80a6e"
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