class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-8.3.1.tgz"
  sha256 "d1e2250c6eb956e84df6b5d4f8127d420efa9142f393652c77a06906e79d69c3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "a1c5829a6bcc334a548270e3b734eeccb7b29d7260339dfa6010893545e46e58"
    sha256 cellar: :any,                 arm64_tahoe:       "a1c5829a6bcc334a548270e3b734eeccb7b29d7260339dfa6010893545e46e58"
    sha256 cellar: :any,                 arm64_sequoia:     "a1c5829a6bcc334a548270e3b734eeccb7b29d7260339dfa6010893545e46e58"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bae9e73a267ceac26a91ff708a641455ce5551c4c295c9fa01a23c5f7e88ec5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0bb9faeafe02cf260d99ae0e433f170dfbfb7ee86437fddd5680fb0c4d8670df"
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