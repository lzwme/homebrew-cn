class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-8.3.2.tgz"
  sha256 "268c70bb56c0a5ff17dbe4b7ebf21e0981697cce707cfaca84317c5b6b1eac56"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "60cfcebc4778e75f44ba47d7e11fbdd7570ab1f50b662839e37f6bd53acf64b9"
    sha256 cellar: :any,                 arm64_tahoe:       "60cfcebc4778e75f44ba47d7e11fbdd7570ab1f50b662839e37f6bd53acf64b9"
    sha256 cellar: :any,                 arm64_sequoia:     "60cfcebc4778e75f44ba47d7e11fbdd7570ab1f50b662839e37f6bd53acf64b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3b1ddfbdec92b3670781c99c89540a3df48a4429ad013ccf3cafcd59ecc3c4ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6f1a83282f720e77b0cfab54e553e84983833bd50f813664141c984ffbb4d3bd"
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