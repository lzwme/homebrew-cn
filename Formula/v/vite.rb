class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-8.3.3.tgz"
  sha256 "a5895f70698d23dfef30418b563c9f369ab99703edf3503815bb5c2ee40baa40"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "e3b5aac7af62d6051cee40bcde3e2c4f9aea10dcd34b27e17ef06450fc1ca2a4"
    sha256 cellar: :any,                 arm64_tahoe:       "e3b5aac7af62d6051cee40bcde3e2c4f9aea10dcd34b27e17ef06450fc1ca2a4"
    sha256 cellar: :any,                 arm64_sequoia:     "e3b5aac7af62d6051cee40bcde3e2c4f9aea10dcd34b27e17ef06450fc1ca2a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "beed5b3a816654e629c8900db579df89aefb50787f81864bd6f917c78da92258"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "107c2e6e67ade47b02fa69c1707127cb26f7480be5c7253247c0842a60ebf5b4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/vite/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end