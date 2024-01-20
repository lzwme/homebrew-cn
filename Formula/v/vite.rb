require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.0.12.tgz"
  sha256 "6acc28f13a37cdcc9a91350bf135b2f3296f8626e7eae4778c07aa36f1b4cabe"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a8c8bb6b702a192faa39a0aa2ae81f57b2253f72bb907c2af402940f6d9713c9"
    sha256 cellar: :any,                 arm64_ventura:  "a8c8bb6b702a192faa39a0aa2ae81f57b2253f72bb907c2af402940f6d9713c9"
    sha256 cellar: :any,                 arm64_monterey: "a8c8bb6b702a192faa39a0aa2ae81f57b2253f72bb907c2af402940f6d9713c9"
    sha256 cellar: :any,                 sonoma:         "e821b8fe4f8687d0235a8830a1e334892d728cc70aaeb1dde3252d75da98f098"
    sha256 cellar: :any,                 ventura:        "e821b8fe4f8687d0235a8830a1e334892d728cc70aaeb1dde3252d75da98f098"
    sha256 cellar: :any,                 monterey:       "e821b8fe4f8687d0235a8830a1e334892d728cc70aaeb1dde3252d75da98f098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26c4f4a2505136182e18fbc74c077bf59f5cac2facd3eaecd8057bfe16da89d4"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec/"lib/node_modules/vite/node_modules"
    (node_modules/"@rollup/rollup-linux-x64-musl/rollup.linux-x64-musl.node").unlink if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end