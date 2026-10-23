class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-8.3.5.tgz"
  sha256 "7f22c2a78d15bac5ad755c5f413806048db453604fa0c293f6a0613890dc7c17"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "fbe1639b0c8af39a937b3f5ef1c2b6a2f1f765815ec0a0bf4687f27a88b05650"
    sha256 cellar: :any,                 arm64_tahoe:       "fbe1639b0c8af39a937b3f5ef1c2b6a2f1f765815ec0a0bf4687f27a88b05650"
    sha256 cellar: :any,                 arm64_sequoia:     "fbe1639b0c8af39a937b3f5ef1c2b6a2f1f765815ec0a0bf4687f27a88b05650"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e1f0d8b4dffa4ba2e143344662a65a1afae03aa8dbc0915c9667206b81a49669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "05485c098799bf45e01a5bc5e265f0eb5eb046eb542e7011d2e3cd717d48a37e"
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