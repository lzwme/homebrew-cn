class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-3.1.2.tgz"
  sha256 "846a5936123f4b2e192011ac0e690ebe7cbeaf24c62c795d721f69668434564e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b5f9c604fb34d8456f1d4ff3cf5b69d67aaeb8114fa71be2708d63f2b2fe7c64"
    sha256 cellar: :any,                 arm64_sequoia: "b5f9c604fb34d8456f1d4ff3cf5b69d67aaeb8114fa71be2708d63f2b2fe7c64"
    sha256 cellar: :any,                 arm64_sonoma:  "b5f9c604fb34d8456f1d4ff3cf5b69d67aaeb8114fa71be2708d63f2b2fe7c64"
    sha256 cellar: :any,                 sonoma:        "aa537e63355b98cb7ec2b191b65370821eae06a145cd7e2b06bc916d040a270d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d50c2ec5f2f120d6100da4c5f0270c04a3361605b2cf9fc9767aca5adc69c468"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b7ebd0094017002517fb422301b7c6d8765c19307c0be32c84a19fa3c3212a2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    return unless OS.mac?

    deuniversalize_machos libexec/"lib/node_modules/@doist/todoist-cli/node_modules/app-path/main"
  end

  def caveats
    <<~EOS
      Looking for the third-party Go CLI previously published under this
      name (by sachaos)? It has been renamed. Install it with:
        brew install todoist-cli-go
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/td --version")
  end
end