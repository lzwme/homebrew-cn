class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.61.tgz"
  sha256 "25ae98f7d4f752c7ae60c4d3582b74da88a51a557d1ed99afec4555ad79921c1"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "9fc763eb39bcf14ea27144e358891df97a2cb19b025b08c7e335ec1e2d2202bc"
    sha256                               arm64_sequoia: "9fc763eb39bcf14ea27144e358891df97a2cb19b025b08c7e335ec1e2d2202bc"
    sha256                               arm64_sonoma:  "9fc763eb39bcf14ea27144e358891df97a2cb19b025b08c7e335ec1e2d2202bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f5ad728bbad83d6e806b570a80ae1f61f8ab11aee087473e732cea29630fbd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ffc78e5ddeca1867426395925c4900f5d59d291cbac8867feaf21c4618ebd55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4aec0702ae8dfa3de7dfcd706a2d1752b31186c84958fbbe8571ed5a20643a3f"
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